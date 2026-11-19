# Changelog

# Changelog

All notable changes to this project are documented in the GitHub Releases page.

## 8.6.0

### Minor Changes

- [`25f9dbe2d69b51cd936b9b131dfb2b865ca1e769`](https://github.com/Cap-go/capacitor-firebase/commit/25f9dbe2d69b51cd936b9b131dfb2b865ca1e769) ([#1037](https://github.com/capawesome-team/capacitor-firebase/pull/1037)): feat: add `code` property to `PhoneVerificationFailedEvent`

### Patch Changes

- [`b8f32c5d52ee8cb467aecfd68428fafd930a23a7`](https://github.com/Cap-go/capacitor-firebase/commit/b8f32c5d52ee8cb467aecfd68428fafd930a23a7) ([#1055](https://github.com/capawesome-team/capacitor-firebase/pull/1055)): fix(ios): reject with `Sign in canceled.` or `Link canceled.` when the Facebook Limited Login flow is cancelled

- [`86883ffef26b034f27c9970c048ace10540f1c5c`](https://github.com/Cap-go/capacitor-firebase/commit/86883ffef26b034f27c9970c048ace10540f1c5c) ([#1049](https://github.com/capawesome-team/capacitor-firebase/pull/1049)): fix(android): reject failed `applyActionCode`, `confirmPasswordReset`, `deleteUser`, `reload`, `sendSignInLinkToEmail`, `updateEmail`, `updatePassword` and `updateProfile` calls

- [`b6f7a48d18ba358f57b1cba52131ba7b60bc7ce0`](https://github.com/Cap-go/capacitor-firebase/commit/b6f7a48d18ba358f57b1cba52131ba7b60bc7ce0) ([#1056](https://github.com/capawesome-team/capacitor-firebase/pull/1056)): fix(ios): resolve Swift compiler warnings for the unused `addStateDidChangeListener` result and the `unowned self` capture in the Google sign-in flow

- [`4ff42fd85508cf06701a5516afb622a0718dabc7`](https://github.com/Cap-go/capacitor-firebase/commit/4ff42fd85508cf06701a5516afb622a0718dabc7) ([#1051](https://github.com/capawesome-team/capacitor-firebase/pull/1051)): fix(android): remove Firebase listeners when the bridge is destroyed so recreated activities no longer leak the previous Activity and WebView

## 8.5.2

### Patch Changes

- [`96e907b0e49a078fdfe5b5947dd9caf2b66117ba`](https://github.com/Cap-go/capacitor-firebase/commit/96e907b0e49a078fdfe5b5947dd9caf2b66117ba) ([#1027](https://github.com/capawesome-team/capacitor-firebase/pull/1027)): fix(android): start Facebook sign-in via `LoginManager` so it no longer hangs once an access token is cached and no longer blocks the main thread at plugin load

- [`d31af687af86b2a4324c8635529e7ddbb0c6d372`](https://github.com/Cap-go/capacitor-firebase/commit/d31af687af86b2a4324c8635529e7ddbb0c6d372) ([#1033](https://github.com/capawesome-team/capacitor-firebase/pull/1033)): fix(android): no longer crash when signing in or linking with Apple or another OAuth provider on a device without a browser

- [`6f90cd36cd27d793d4e74f17416e0cc82200a9d8`](https://github.com/Cap-go/capacitor-firebase/commit/6f90cd36cd27d793d4e74f17416e0cc82200a9d8) ([#1031](https://github.com/capawesome-team/capacitor-firebase/pull/1031)): fix(ios): no longer crash at launch when `GoogleService-Info.plist` is missing

## 8.5.1

### Patch Changes

- [`a613e7b41c3c7a8cecf82c3cffc7573f290fae15`](https://github.com/Cap-go/capacitor-firebase/commit/a613e7b41c3c7a8cecf82c3cffc7573f290fae15) ([#1021](https://github.com/capawesome-team/capacitor-firebase/pull/1021)): fix(android): use the Google button flow with Credential Manager

- [`bbfd3b8b3d96963fc30f5bb9dc288c63279a04b1`](https://github.com/Cap-go/capacitor-firebase/commit/bbfd3b8b3d96963fc30f5bb9dc288c63279a04b1) ([#1023](https://github.com/capawesome-team/capacitor-firebase/pull/1023)): fix(ios): remove the SPM test target that made the published package unresolvable by SwiftPM

## 8.5.0

### Minor Changes

- [`cf087eea2eff30e8f7ded8ed22b4fdaee0ea6e72`](https://github.com/Cap-go/capacitor-firebase/commit/cf087eea2eff30e8f7ded8ed22b4fdaee0ea6e72) ([#1013](https://github.com/capawesome-team/capacitor-firebase/pull/1013)): feat(ios): upstream added optional Swift Package Manager traits for GoogleSignIn and the Facebook SDK (Capgo ships both SDKs unconditionally in `Package.swift`)

### Patch Changes

- [`cf087eea2eff30e8f7ded8ed22b4fdaee0ea6e72`](https://github.com/Cap-go/capacitor-firebase/commit/cf087eea2eff30e8f7ded8ed22b4fdaee0ea6e72) ([#1013](https://github.com/capawesome-team/capacitor-firebase/pull/1013)): fix(ios): reject instead of never resolving when signing in with or linking a provider whose SDK is not included in the build

## 8.4.0

### Patch Changes

- [`3e70b6569ffa36c00b3b75cb1490e3efbab35f23`](https://github.com/Cap-go/capacitor-firebase/commit/3e70b6569ffa36c00b3b75cb1490e3efbab35f23) ([#1006](https://github.com/capawesome-team/capacitor-firebase/pull/1006)): fix: update CocoaPods dependency constraints in the podspec files to allow minor updates

## 8.3.0

## 8.2.0

### Patch Changes

- [`cbdc8030397534d3fca25647ea03c47fdfd91303`](https://github.com/Cap-go/capacitor-firebase/commit/cbdc8030397534d3fca25647ea03c47fdfd91303) ([#954](https://github.com/capawesome-team/capacitor-firebase/pull/954)): fix: reject calls when provider is not configured

## 8.1.0

### Patch Changes

- [`4da8bb58d5144995ad451487f79a1e887b3b8a7f`](https://github.com/Cap-go/capacitor-firebase/commit/4da8bb58d5144995ad451487f79a1e887b3b8a7f) ([#952](https://github.com/capawesome-team/capacitor-firebase/pull/952)): fix(android): AGP 9.0 no longer supports `proguard-android.txt`

## 8.0.1
**[Click here to view all releases →](../../releases)**
