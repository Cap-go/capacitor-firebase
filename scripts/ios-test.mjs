#!/usr/bin/env node
// Runs the PluginTests XCTest bundle of the package in the current directory on an iOS Simulator.
// This replaces the old compile-only `xcodebuild -destination generic/platform=iOS` step: the
// simulator build compiles the same Swift sources and then runs the tests.
//
// Speed notes for CI:
// - Pin arm64 only (ONLY_ACTIVE_ARCH) so xcodebuild does not also compile x86_64.
// - Disable the compiler index store; it is unused in this smoke test and adds compile time.
// - Reuse IOS_TEST_UDID when set, otherwise prefer an already-booted iPhone, else the newest one.
// - Simulator signing is skipped (CODE_SIGNING_ALLOWED=NO).
// - IPHONEOS_DEPLOYMENT_TARGET=15.0 so older pod targets still compile on Xcode 27.
// IOS_TEST_DERIVED_DATA optionally sets xcodebuild's -derivedDataPath.
import { spawnSync } from 'node:child_process';

const run = (cmd, args, options = {}) =>
  spawnSync(cmd, args, { stdio: 'inherit', ...options });

const elapsed = started => `${((Date.now() - started) / 1000).toFixed(1)}s`;

const listAvailablePhones = () => {
  const listed = spawnSync(
    'xcrun',
    ['simctl', 'list', 'devices', 'available', '-j'],
    { encoding: 'utf8' },
  );
  if (listed.status !== 0) {
    throw new Error(`simctl list failed: ${listed.stderr}`);
  }
  const devices = JSON.parse(listed.stdout).devices;
  const version = runtime =>
    runtime
      .replace(/^.*iOS-/, '')
      .split('-')
      .map(Number);
  const compare = (a, b) => {
    for (let i = 0; i < Math.max(a.length, b.length); i++) {
      if ((a[i] ?? 0) !== (b[i] ?? 0)) {
        return (b[i] ?? 0) - (a[i] ?? 0);
      }
    }
    return 0;
  };
  const runtimes = Object.keys(devices)
    .filter(key => key.includes('SimRuntime.iOS-'))
    .sort((a, b) => compare(version(a), version(b)));
  const phones = [];
  for (const runtime of runtimes) {
    for (const device of devices[runtime]) {
      if (device.isAvailable && device.name.startsWith('iPhone')) {
        phones.push(device);
      }
    }
  }
  return phones;
};

const pickSimulator = () => {
  if (process.env.IOS_TEST_UDID) {
    return process.env.IOS_TEST_UDID;
  }
  const phones = listAvailablePhones();
  const booted = phones.find(device => device.state === 'Booted');
  if (booted) {
    return booted.udid;
  }
  if (phones[0]) {
    return phones[0].udid;
  }
  throw new Error('No available iPhone simulator found');
};

const started = Date.now();
const udid = pickSimulator();
console.log(`ios-test: simulator ${udid}`);
const bootStarted = Date.now();
if (run('xcrun', ['simctl', 'bootstatus', udid, '-b']).status !== 0) {
  process.exit(1);
}
console.log(`ios-test: simulator ready in ${elapsed(bootStarted)}`);

const destination = `platform=iOS Simulator,id=${udid},arch=arm64`;
// `--spm <scheme>` tests the package through its Package.swift instead of the CocoaPods
// workspace. Firebase then comes in as prebuilt SPM binaries (FirebaseFirestoreInternal, gRPC,
// abseil), while the CocoaPods workspace compiles gRPC/BoringSSL/abseil from source.
const spmIndex = process.argv.indexOf('--spm');
const spmScheme = spmIndex === -1 ? undefined : process.argv[spmIndex + 1];
if (spmIndex !== -1 && !spmScheme) {
  console.error('ios-test: --spm needs a scheme name');
  process.exit(1);
}
const project = spmScheme
  ? ['-scheme', spmScheme]
  : ['-workspace', 'Plugin.xcworkspace', '-scheme', 'Plugin'];
const args = [
  ...project,
  '-destination',
  destination,
  '-parallel-testing-enabled',
  'NO',
  'ONLY_ACTIVE_ARCH=YES',
  'COMPILER_INDEX_STORE_ENABLE=NO',
  'CODE_SIGNING_ALLOWED=NO',
  'IPHONEOS_DEPLOYMENT_TARGET=15.0',
];
if (process.env.IOS_TEST_DERIVED_DATA) {
  args.push('-derivedDataPath', process.env.IOS_TEST_DERIVED_DATA);
}
args.push('test');
console.log(`ios-test: xcodebuild ${args.join(' ')}`);
const testStarted = Date.now();
const result = run('xcodebuild', args, { cwd: spmScheme ? '.' : 'ios' });
console.log(
  `ios-test: xcodebuild test finished in ${elapsed(testStarted)} (total ${elapsed(started)})`,
);
process.exit(result.status ?? 1);
