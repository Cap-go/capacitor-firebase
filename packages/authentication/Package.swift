// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapgoCapacitorFirebaseAuthentication",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "CapgoCapacitorFirebaseAuthentication",
            targets: ["CapgoFirebaseAuthenticationPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor.git", from: "9.0.0-beta.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "12.9.0")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "9.1.0"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk.git", from: "18.0.0")
    ],
    targets: [
        .target(
            name: "CapgoFirebaseAuthenticationPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "FacebookCore", package: "facebook-ios-sdk"),
                .product(name: "FacebookLogin", package: "facebook-ios-sdk")
            ],
            path: "ios/Plugin",
            swiftSettings: [
                .define("RGCFA_INCLUDE_GOOGLE"),
                .define("RGCFA_INCLUDE_FACEBOOK")
            ]),
        .testTarget(
            name: "CapgoFirebaseAuthenticationPluginTests",
            dependencies: ["CapgoFirebaseAuthenticationPlugin"],
            path: "ios/PluginTests")
    ]
)
