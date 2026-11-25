# Changelog

# Changelog

All notable changes to this project are documented in the GitHub Releases page.

## 8.6.2

### Minor Changes

- [`e28d2de2`](https://github.com/capawesome-team/capacitor-firebase/commit/e28d2de2) ([#1071](https://github.com/capawesome-team/capacitor-firebase/pull/1071)): feat(firestore): add `terminate` method

### Patch Changes

- [`ac4ee6c7`](https://github.com/capawesome-team/capacitor-firebase/commit/ac4ee6c7) ([#1076](https://github.com/capawesome-team/capacitor-firebase/pull/1076)): fix(firestore): fix three error paths on Android and iOS

## 8.6.0

### Patch Changes

- [`d1238f61c5595708e58f7f626130c896e70f0d82`](https://github.com/Cap-go/capacitor-firebase/commit/d1238f61c5595708e58f7f626130c896e70f0d82) ([#1048](https://github.com/capawesome-team/capacitor-firebase/pull/1048)): fix(android): handle missing data in write batch delete operation

- [`b6f7a48d18ba358f57b1cba52131ba7b60bc7ce0`](https://github.com/Cap-go/capacitor-firebase/commit/b6f7a48d18ba358f57b1cba52131ba7b60bc7ce0) ([#1056](https://github.com/capawesome-team/capacitor-firebase/pull/1056)): fix(ios): remove unreachable `catch` blocks in `addCollectionSnapshotListener` and `addCollectionGroupSnapshotListener`

## 8.5.2

### Patch Changes

- [`6f90cd36cd27d793d4e74f17416e0cc82200a9d8`](https://github.com/Cap-go/capacitor-firebase/commit/6f90cd36cd27d793d4e74f17416e0cc82200a9d8) ([#1031](https://github.com/capawesome-team/capacitor-firebase/pull/1031)): fix(ios): no longer crash at launch when `GoogleService-Info.plist` is missing

## 8.5.1

### Patch Changes

- [`bbfd3b8b3d96963fc30f5bb9dc288c63279a04b1`](https://github.com/Cap-go/capacitor-firebase/commit/bbfd3b8b3d96963fc30f5bb9dc288c63279a04b1) ([#1023](https://github.com/capawesome-team/capacitor-firebase/pull/1023)): fix(ios): remove the SPM test target that made the published package unresolvable by SwiftPM

## 8.5.0

## 8.4.0

### Patch Changes

- [`3e70b6569ffa36c00b3b75cb1490e3efbab35f23`](https://github.com/Cap-go/capacitor-firebase/commit/3e70b6569ffa36c00b3b75cb1490e3efbab35f23) ([#1006](https://github.com/capawesome-team/capacitor-firebase/pull/1006)): fix: update CocoaPods dependency constraints in the podspec files to allow minor updates

## 8.3.0

### Minor Changes

- [`a5fe048d2efb57dc195b0b99b375d85e6402c224`](https://github.com/Cap-go/capacitor-firebase/commit/a5fe048d2efb57dc195b0b99b375d85e6402c224) ([#988](https://github.com/capawesome-team/capacitor-firebase/pull/988)): feat: support queries in `getCountFromServer`

- [`7a1b9b7b17823b37d8fe090771c82bb646993028`](https://github.com/Cap-go/capacitor-firebase/commit/7a1b9b7b17823b37d8fe090771c82bb646993028) ([#991](https://github.com/capawesome-team/capacitor-firebase/pull/991)): feat(firestore): add support for `DocumentReference`, `Bytes`, `NaN`, and `Infinity` data types across all platforms

- [`34dbed61bb86c64e0a68b35382cd03cceabb0821`](https://github.com/Cap-go/capacitor-firebase/commit/34dbed61bb86c64e0a68b35382cd03cceabb0821) ([#993](https://github.com/capawesome-team/capacitor-firebase/pull/993)): feat(firestore): support `serverTimestamps` behavior option for `addDocumentSnapshotListener(...)`, `addCollectionSnapshotListener(...)`, and `addCollectionGroupSnapshotListener(...)`

### Patch Changes

- [`52ce77d30eb39315beac86282a09df2f24fb14e9`](https://github.com/Cap-go/capacitor-firebase/commit/52ce77d30eb39315beac86282a09df2f24fb14e9) ([#992](https://github.com/capawesome-team/capacitor-firebase/pull/992)): fix(firestore): handle `limitToLast` query constraint on Android

- [`dff85f9a2029843390d191786e4ae212b85fb061`](https://github.com/Cap-go/capacitor-firebase/commit/dff85f9a2029843390d191786e4ae212b85fb061) ([#989](https://github.com/capawesome-team/capacitor-firebase/pull/989)): fix: generate unique listener/callback IDs on web so listeners created in the same millisecond do not overwrite each other

- [`79c95bc5fc821f8f420d7b04bcab3fffbff8215a`](https://github.com/Cap-go/capacitor-firebase/commit/79c95bc5fc821f8f420d7b04bcab3fffbff8215a) ([#981](https://github.com/capawesome-team/capacitor-firebase/pull/981)): fix(firestore): handle `DocumentReference` fields in the web deserializer to prevent `Maximum call stack size exceeded`

## 8.2.0

### Minor Changes

- [`78c174d9fece08831dedc48ef8cbec26516cfc16`](https://github.com/Cap-go/capacitor-firebase/commit/78c174d9fece08831dedc48ef8cbec26516cfc16) ([#966](https://github.com/capawesome-team/capacitor-firebase/pull/966)): feat: add `databaseId` configuration option

- [`199e56c0565e526ead9c75d18a7ec95cc4f9d870`](https://github.com/Cap-go/capacitor-firebase/commit/199e56c0565e526ead9c75d18a7ec95cc4f9d870) ([#961](https://github.com/capawesome-team/capacitor-firebase/pull/961)): feat: add `enablePersistence` and `disablePersistence` methods

- [`5467d1314553ce27a929a893c71bf80221cb6569`](https://github.com/Cap-go/capacitor-firebase/commit/5467d1314553ce27a929a893c71bf80221cb6569): feat: add support for Timestamp, GeoPoint, and FieldValue data types

## 8.1.0

### Patch Changes

- [`4da8bb58d5144995ad451487f79a1e887b3b8a7f`](https://github.com/Cap-go/capacitor-firebase/commit/4da8bb58d5144995ad451487f79a1e887b3b8a7f) ([#952](https://github.com/capawesome-team/capacitor-firebase/pull/952)): fix(android): AGP 9.0 no longer supports `proguard-android.txt`

## 8.0.1
**[Click here to view all releases →](../../releases)**
