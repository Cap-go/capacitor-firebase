// node --test scripts/release-type.test.cjs
const test = require('node:test');
const assert = require('node:assert/strict');
const { execFileSync } = require('node:child_process');
const { mkdtempSync, mkdirSync, writeFileSync, rmSync } = require('node:fs');
const { tmpdir } = require('node:os');
const path = require('node:path');
const { releaseType, classify } = require('./release-type.cjs');

function repo() {
  const dir = mkdtempSync(path.join(tmpdir(), 'release-type-'));
  const git = (...args) =>
    execFileSync('git', args, { cwd: dir, stdio: 'pipe' });
  git('init', '-q', '-b', 'main');
  git('config', 'user.email', 'test@example.com');
  git('config', 'user.name', 'test');
  git('config', 'tag.gpgSign', 'false');
  git('config', 'commit.gpgSign', 'false');
  const touch = (pkg, version, msg) => {
    mkdirSync(path.join(dir, 'packages', pkg), { recursive: true });
    writeFileSync(
      path.join(dir, 'packages', pkg, 'package.json'),
      JSON.stringify({ name: pkg, version }) + '\n',
    );
    writeFileSync(
      path.join(dir, 'packages', pkg, 'file.txt'),
      `${msg}\n${Math.random()}\n`,
    );
    git('add', '-A');
    git('commit', '-q', '-m', msg);
  };
  const tag = name => git('tag', '-a', name, '-m', name);
  return {
    dir,
    touch,
    tag,
    pkg: p => path.join(dir, 'packages', p),
    done: () => rmSync(dir, { recursive: true, force: true }),
  };
}

test('classify: feat, breaking and others', () => {
  assert.equal(classify('feat: ship ESM only (#34)'), 'minor');
  assert.equal(classify('feat(app)!: drop CommonJS'), 'minor');
  assert.equal(classify('fix: thing\n\nBREAKING CHANGE: api'), 'minor');
  assert.equal(classify('fix: typo'), 'patch');
  assert.equal(classify('chore(release): app 8.6.3'), 'patch');
  assert.equal(classify('docs: update documentation for app'), 'patch');
});

test('feat since the package tag gives minor, even with old breaking history', () => {
  const r = repo();
  try {
    r.touch('analytics', '8.6.0', 'feat!: old breaking change from 2022');
    r.touch('analytics', '8.6.1', 'chore(release): analytics 8.6.1');
    r.tag('analytics/v8.6.1');
    r.touch('analytics', '8.6.1', 'feat: ship ESM only (#34)');
    assert.equal(releaseType(r.pkg('analytics')).releaseAs, 'minor');
  } finally {
    r.done();
  }
});

test('fix since the package tag gives patch; other packages and their tags are ignored', () => {
  const r = repo();
  try {
    r.touch('app', '8.6.2', 'chore(release): app 8.6.2');
    r.tag('app/v8.6.2');
    r.touch('storage', '8.6.1', 'feat: storage only feature');
    r.tag('storage/v9.0.0');
    r.touch('app', '8.6.2', 'fix: app bug');
    assert.equal(releaseType(r.pkg('app')).releaseAs, 'patch');
  } finally {
    r.done();
  }
});

test('prerelease and unreachable tags are not the base', () => {
  const r = repo();
  try {
    r.touch('appcheck', '8.6.1', 'chore(release): appcheck 8.6.1');
    r.tag('appcheck/v8.6.1');
    r.tag('appcheck/v9.0.0-beta.0');
    r.touch('appcheck', '8.6.1', 'feat: new option');
    assert.deepEqual(releaseType(r.pkg('appcheck')), {
      releaseAs: 'minor',
      reason: '1 commit(s) since appcheck/v8.6.1',
    });
  } finally {
    r.done();
  }
});

test('package.json above the latest tag releases exactly that version', () => {
  const r = repo();
  try {
    r.touch('functions', '8.6.2', 'chore(release): functions 8.6.2');
    r.tag('functions/v8.6.2');
    r.touch(
      'functions',
      '8.7.0',
      'fix: release the ESM-only change as a minor',
    );
    assert.equal(releaseType(r.pkg('functions')).releaseAs, '8.7.0');
  } finally {
    r.done();
  }
});

test('package.json that would change the major is refused', () => {
  const r = repo();
  try {
    r.touch('storage', '8.6.2', 'chore(release): storage 8.6.2');
    r.tag('storage/v8.6.2');
    r.touch('storage', '9.0.0', 'fix: wrong major');
    assert.throws(() => releaseType(r.pkg('storage')), /changes the major/);
  } finally {
    r.done();
  }
});
