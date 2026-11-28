import XCTest
import Capacitor
#if canImport(Plugin)
@testable import Plugin
#elseif canImport(CapgoFirebaseAppPlugin)
@testable import CapgoFirebaseAppPlugin
#endif

final class FirebaseAppPluginTests: XCTestCase {
    func testRegistersExpectedMethods() {
        let plugin = FirebaseAppPlugin()
        XCTAssertEqual(plugin.identifier, "FirebaseAppPlugin")
        XCTAssertEqual(plugin.jsName, "FirebaseApp")
        XCTAssertEqual(plugin.pluginMethods.map(\.name), [
            "getApps",
            "getName",
            "getOptions",
            "initializeApp",
            "getPluginVersion"
        ])
    }

    func testGetPluginVersionResolvesWithNonEmptyVersion() {
        let plugin = FirebaseAppPlugin()
        let outcome = invoke(plugin.getPluginVersion, method: "getPluginVersion")
        XCTAssertNil(outcome.message)
        let version = outcome.data?["version"] as? String
        XCTAssertEqual(version?.isEmpty, false)
        XCTAssertNotNil(version?.range(of: #"^\d+\.\d+\.\d+"#, options: .regularExpression))
    }

    func testGetNameRejectsWhenFirebaseIsNotConfigured() {
        let plugin = FirebaseAppPlugin()
        let outcome = invoke(plugin.getName, method: "getName")
        XCTAssertEqual(
            outcome.message,
            "Firebase is not configured: GoogleService-Info.plist is missing from the app bundle."
        )
    }

    func testInitializeAppOptionsRejectsMissingName() {
        let call = makeCall(method: "initializeApp")
        XCTAssertThrowsError(try InitializeAppOptions(call)) { error in
            XCTAssertEqual(
                (error as? CustomError)?.localizedDescription,
                CustomError.nameMissing.localizedDescription
            )
        }
    }

    func testInitializeAppOptionsRejectsInvalidName() {
        let call = makeCall(method: "initializeApp", options: ["name": "bad name"])
        XCTAssertThrowsError(try InitializeAppOptions(call)) { error in
            XCTAssertEqual(
                (error as? CustomError)?.localizedDescription,
                CustomError.nameInvalid.localizedDescription
            )
        }
    }

    func testInitializeAppOptionsRejectsInvalidApplicationId() {
        let apiKey = "A" + String(repeating: "a", count: 38)
        let call = makeCall(method: "initializeApp", options: [
            "name": "default",
            "options": [
                "apiKey": apiKey,
                "applicationId": "not-an-ios-app-id",
                "gcmSenderId": "123",
                "projectId": "proj"
            ]
        ])
        XCTAssertThrowsError(try InitializeAppOptions(call)) { error in
            XCTAssertEqual(
                (error as? CustomError)?.localizedDescription,
                CustomError.applicationIdInvalid.localizedDescription
            )
        }
    }

}

private final class PluginCallOutcome {
    var data: [String: Any]?
    var message: String?
}

private func invoke(
    _ method: (CAPPluginCall) -> Void,
    method methodName: String,
    options: [String: Any] = [:]
) -> PluginCallOutcome {
    let outcome = PluginCallOutcome()
    let settled = XCTestExpectation(description: methodName)
    let call = CAPPluginCall(
        callbackId: "test",
        methodName: methodName,
        options: options,
        success: { result, _ in
            outcome.data = result?.data
            settled.fulfill()
        },
        error: { err in
            outcome.message = err?.message
            settled.fulfill()
        }
    )
    method(call)
    if XCTWaiter.wait(for: [settled], timeout: 5) != .completed {
        XCTFail("\(methodName) did not settle")
    }
    return outcome
}

private func makeCall(method: String, options: [String: Any] = [:]) -> CAPPluginCall {
    CAPPluginCall(
        callbackId: "test",
        methodName: method,
        options: options,
        success: { _, _ in },
        error: { _ in }
    )
}

