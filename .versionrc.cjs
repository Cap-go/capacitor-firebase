// Loaded by capacitor-plugin-standard-version (commit-and-tag-version) from each packages/<pkg>
// directory in .github/workflows/bump_version.yml. Supplies a tag-scoped `releaseAs`, because the
// tool drops the workflow's --tag-prefix. See scripts/release-type.cjs.
const { releaseType } = require('./scripts/release-type.cjs');

module.exports = () => {
  const { releaseAs, reason } = releaseType(process.cwd());
  console.error(`release-type: ${releaseAs} (${reason})`);
  return { releaseAs };
};
