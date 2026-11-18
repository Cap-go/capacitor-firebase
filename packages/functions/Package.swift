// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapgoCapacitorFirebaseFunctions",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "CapgoCapacitorFirebaseFunctions",
            targets: ["CapgoFirebaseFunctionsPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor.git", from: "9.0.0-beta.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "12.9.0"))
    ],
    targets: [
        .target(
            name: "CapgoFirebaseFunctionsPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor"),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFunctions", package: "firebase-ios-sdk")
            ],
            path: "ios/Plugin"),
        .testTarget(
            name: "CapgoFirebaseFunctionsPluginTests",
            dependencies: ["CapgoFirebaseFunctionsPlugin"],
            path: "ios/PluginTests")
    ]
)
