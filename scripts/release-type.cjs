/**
 * Per-package release type for the bump workflow (.github/workflows/bump_version.yml).
 *
 * capacitor-plugin-standard-version merges its own defaults over the CLI arguments, and those
 * defaults contain `tagPrefix: ""`. The workflow's `--tag-prefix "<pkg>/v"` is therefore dropped,
 * no `<pkg>/vX.Y.Z` tag is found, and the recommended bump is computed from the package's whole
 * history, where old BREAKING commits force a 9.0.0 recommendation that the workflow then turns
 * into a patch. This module does the tag-scoped calculation itself and hands the result to the
 * tool as `releaseAs` through the root `.versionrc.cjs` (config values are not overridden).
 *
 * Rules, for the commits since the latest stable `<pkg>/v*` tag reachable from HEAD that touch
 * `packages/<pkg>`:
 *   - package.json version already above that tag (and not tagged yet): release exactly that version
 *   - `feat` or a breaking change (`!` / `BREAKING CHANGE`): minor (major stays aligned with Capacitor)
 *   - anything else: patch
 */
const { execFileSync } = require('node:child_process');
const { readFileSync } = require('node:fs');
const path = require('node:path');

const STABLE = /^(\d+)\.(\d+)\.(\d+)$/;

function git(cwd, args) {
  return execFileSync('git', args, {
    cwd,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
  }).trim();
}

function compare(a, b) {
  const x = a.match(STABLE).slice(1).map(Number);
  const y = b.match(STABLE).slice(1).map(Number);
  return x[0] - y[0] || x[1] - y[1] || x[2] - y[2];
}

function latestTag(repo, pkg) {
  const prefix = `${pkg}/v`;
  const versions = git(repo, [
    'tag',
    '--merged',
    'HEAD',
    '--list',
    `${prefix}*`,
  ])
    .split('\n')
    .map(t => t.slice(prefix.length))
    .filter(v => STABLE.test(v))
    .sort(compare);
  return versions.length ? versions[versions.length - 1] : null;
}

function classify(message) {
  const header = message.split('\n', 1)[0];
  const m = header.match(/^(\w+)(?:\([^)]*\))?(!)?:/);
  const breaking = Boolean(m && m[2]) || /^BREAKING[ -]CHANGE:/m.test(message);
  if (breaking || (m && m[1] === 'feat')) return 'minor';
  return 'patch';
}

function releaseType(pkgDir) {
  const dir = path.resolve(pkgDir);
  const pkg = path.basename(dir);
  const repo = git(dir, ['rev-parse', '--show-toplevel']);
  const version = JSON.parse(
    readFileSync(path.join(dir, 'package.json'), 'utf8'),
  ).version;
  const tag = latestTag(repo, pkg);

  if (tag && STABLE.test(version) && compare(version, tag) > 0) {
    const tagged = git(repo, ['tag', '--list', `${pkg}/v${version}`]);
    if (!tagged) {
      if (version.split('.')[0] !== tag.split('.')[0]) {
        throw new Error(
          `${pkg}: package.json ${version} changes the major of ${pkg}/v${tag}; not allowed in CI`,
        );
      }
      return {
        releaseAs: version,
        reason: `package.json ${version} is above ${pkg}/v${tag} and untagged`,
      };
    }
  }

  const range = tag ? [`${pkg}/v${tag}..HEAD`] : ['HEAD'];
  const out = git(repo, [
    'log',
    '--format=%B%x00',
    ...range,
    '--',
    path.relative(repo, dir),
  ]);
  const messages = out
    .split('\0')
    .map(s => s.trim())
    .filter(Boolean);
  const type = messages.some(msg => classify(msg) === 'minor')
    ? 'minor'
    : 'patch';
  const since = tag ? `${pkg}/v${tag}` : 'the first commit';
  return {
    releaseAs: type,
    reason: `${messages.length} commit(s) since ${since}`,
  };
}

module.exports = { releaseType, classify, latestTag };

if (require.main === module) {
  const r = releaseType(process.argv[2] || '.');
  console.log(`${r.releaseAs} (${r.reason})`);
}
