#!/usr/bin/env node
// Runs the PluginTests XCTest bundle of the package in the current directory on an iOS Simulator.
// This replaces the old compile-only `xcodebuild -destination generic/platform=iOS` step: the
// simulator build compiles the same Swift sources and then runs the tests.
// IOS_TEST_UDID pins a simulator, otherwise the newest available iPhone is booted.
// IOS_TEST_DERIVED_DATA optionally sets xcodebuild's -derivedDataPath.
import { spawnSync } from 'node:child_process';

const run = (cmd, args, options = {}) => spawnSync(cmd, args, { stdio: 'inherit', ...options });

const pickSimulator = () => {
  if (process.env.IOS_TEST_UDID) {
    return process.env.IOS_TEST_UDID;
  }
  const listed = spawnSync('xcrun', ['simctl', 'list', 'devices', 'available', '-j'], { encoding: 'utf8' });
  if (listed.status !== 0) {
    throw new Error(`simctl list failed: ${listed.stderr}`);
  }
  const devices = JSON.parse(listed.stdout).devices;
  const version = (runtime) => runtime.replace(/^.*iOS-/, '').split('-').map(Number);
  const compare = (a, b) => {
    for (let i = 0; i < Math.max(a.length, b.length); i++) {
      if ((a[i] ?? 0) !== (b[i] ?? 0)) {
        return (b[i] ?? 0) - (a[i] ?? 0);
      }
    }
    return 0;
  };
  const runtimes = Object.keys(devices)
    .filter((key) => key.includes('SimRuntime.iOS-'))
    .sort((a, b) => compare(version(a), version(b)));
  for (const runtime of runtimes) {
    const phone = devices[runtime].find((device) => device.isAvailable && device.name.startsWith('iPhone'));
    if (phone) {
      return phone.udid;
    }
  }
  throw new Error('No available iPhone simulator found');
};

const udid = pickSimulator();
console.log(`ios-test: simulator ${udid}`);
if (run('xcrun', ['simctl', 'bootstatus', udid, '-b']).status !== 0) {
  process.exit(1);
}
const args = ['-workspace', 'Plugin.xcworkspace', '-scheme', 'Plugin', '-destination', `id=${udid}`];
if (process.env.IOS_TEST_DERIVED_DATA) {
  args.push('-derivedDataPath', process.env.IOS_TEST_DERIVED_DATA);
}
const result = run('xcodebuild', [...args, 'test'], { cwd: 'ios' });
process.exit(result.status ?? 1);
