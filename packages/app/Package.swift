// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapgoCapacitorFirebaseApp",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "CapgoCapacitorFirebaseApp",
            targets: ["CapgoFirebaseAppPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor.git", from: "9.0.0-beta.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "12.9.0"))
    ],
    targets: [
        .target(
            name: "CapgoFirebaseAppPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor"),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk")
            ],
            path: "ios/Plugin"),
        .testTarget(
            name: "CapgoFirebaseAppPluginTests",
            dependencies: ["CapgoFirebaseAppPlugin"],
            path: "ios/PluginTests")
    ]
)
