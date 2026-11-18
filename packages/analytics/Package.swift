// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CapgoCapacitorFirebaseAnalytics",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "CapgoCapacitorFirebaseAnalytics",
            targets: ["CapgoFirebaseAnalyticsPlugin"])
    ],
    traits: [
        .default(enabledTraits: ["Analytics"]),
        .trait(
            name: "Analytics",
            description: "Includes IDFA collection support."
        ),
        .trait(
            name: "AnalyticsWithoutAdIdSupport",
            description: "Disables IDFA collection."
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor.git", from: "9.0.0-beta.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "12.9.0"))
    ],
    targets: [
        .target(
            name: "CapgoFirebaseAnalyticsPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk",
                         condition: .when(traits: ["Analytics"])),
                .product(name: "FirebaseAnalyticsCore", package: "firebase-ios-sdk",
                         condition: .when(traits: ["AnalyticsWithoutAdIdSupport"])),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk")
            ],
            path: "ios/Plugin"),
        .testTarget(
            name: "CapgoFirebaseAnalyticsPluginTests",
            dependencies: ["CapgoFirebaseAnalyticsPlugin"],
            path: "ios/PluginTests")
    ],
    swiftLanguageModes: [.v5]
)
