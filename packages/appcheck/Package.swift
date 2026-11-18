// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CapgoCapacitorFirebaseAppCheck",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "CapgoCapacitorFirebaseAppCheck",
            targets: ["CapgoFirebaseAppCheckPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor.git", from: "9.0.0-beta.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "12.9.0")),
        .package(name: "google-app-check", url: "https://github.com/google/app-check.git", "11.0.1"..<"12.0.0")
    ],
    targets: [
        .target(
            name: "CapgoFirebaseAppCheckPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor"),
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
