const base = require('@ionic/swiftlint-config');

module.exports = {
  ...base,
  type_body_length: { warning: 500, error: 600 },
  excluded: [
    ...(base.excluded || []).map(p => p.replace('${PWD}', process.cwd())),
    `${process.cwd()}/.build`,
    `${process.cwd()}/example`,
  ],
};
