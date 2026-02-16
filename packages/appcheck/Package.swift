// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CapgoCapacitorFirebaseAppCheck",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CapgoCapacitorFirebaseAppCheck",
            targets: ["CapgoFirebaseAppCheckPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "12.9.0")),
        .package(name: "google-app-check", url: "https://github.com/google/app-check.git", "11.0.1"..<"12.0.0")
    ],
    targets: [
        .target(
            name: "CapgoFirebaseAppCheckPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "AppCheckCore", package: "google-app-check"),
                .product(name: "FirebaseAppCheck", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk")
            ],
            path: "ios/Plugin"),
        .testTarget(
            name: "CapgoFirebaseAppCheckPluginTests",
            dependencies: ["CapgoFirebaseAppCheckPlugin"],
            path: "ios/PluginTests")
    ]
)
