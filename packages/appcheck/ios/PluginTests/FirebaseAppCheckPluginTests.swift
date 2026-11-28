import XCTest
import Capacitor
#if canImport(Plugin)
@testable import Plugin
#elseif canImport(CapgoFirebaseAppCheckPlugin)
@testable import CapgoFirebaseAppCheckPlugin
#endif

final class FirebaseAppCheckPluginTests: XCTestCase {
    func testRegistersExpectedMethods() {
        let plugin = FirebaseAppCheckPlugin()
        XCTAssertEqual(plugin.identifier, "FirebaseAppCheckPlugin")
        XCTAssertEqual(plugin.jsName, "FirebaseAppCheck")
        XCTAssertEqual(plugin.pluginMethods.map(\.name), [
            "getToken",
            "initialize",
            "setTokenAutoRefreshEnabled",
            "getPluginVersion"
        ])
    }

    func testGetPluginVersionResolvesWithNonEmptyVersion() {
        let plugin = FirebaseAppCheckPlugin()
        let outcome = invoke(plugin.getPluginVersion, method: "getPluginVersion")
        XCTAssertNil(outcome.message)
        let version = outcome.data?["version"] as? String
        XCTAssertEqual(version?.isEmpty, false)
        XCTAssertNotNil(version?.range(of: #"^\d+\.\d+\.\d+"#, options: .regularExpression))
    }

    func testGetTokenRejectsWhenFirebaseIsNotConfigured() {
        let plugin = FirebaseAppCheckPlugin()
        let outcome = invoke(plugin.getToken, method: "getToken", options: ["forceRefresh": false])
        XCTAssertEqual(outcome.message, plugin.errorFirebaseNotConfigured)
        XCTAssertNil(outcome.data)
    }

    func testSetTokenAutoRefreshEnabledRejectsWhenEnabledIsMissing() throws {
        let plugin = FirebaseAppCheckPlugin()
        let outcome = invoke(plugin.setTokenAutoRefreshEnabled, method: "setTokenAutoRefreshEnabled")
        XCTAssertEqual(outcome.message, plugin.errorEnabledMissing)
        XCTAssertNil(outcome.data)
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
    guard let call = CAPPluginCall(
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
    ) else {
        XCTFail("failed to create CAPPluginCall for \(methodName)")
        return outcome
    }
    method(call)
    if XCTWaiter.wait(for: [settled], timeout: 5) != .completed {
        XCTFail("\(methodName) did not settle")
    }
    return outcome
}

private func makeCall(method: String, options: [String: Any] = [:]) throws -> CAPPluginCall {
    try XCTUnwrap(
        CAPPluginCall(
            callbackId: "test",
            methodName: method,
            options: options,
            success: { _, _ in },
            error: { _ in }
        ),
        "failed to create CAPPluginCall"
    )
}

