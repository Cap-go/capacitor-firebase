import XCTest
import Capacitor
#if canImport(Plugin)
@testable import Plugin
#elseif canImport(CapgoFirebaseFunctionsPlugin)
@testable import CapgoFirebaseFunctionsPlugin
#endif

final class FirebaseFunctionsPluginTests: XCTestCase {
    func testRegistersExpectedMethods() {
        let plugin = FirebaseFunctionsPlugin()
        XCTAssertEqual(plugin.identifier, "FirebaseFunctionsPlugin")
        XCTAssertEqual(plugin.jsName, "FirebaseFunctions")
        XCTAssertEqual(plugin.pluginMethods.map(\.name), [
            "callByName",
            "callByUrl",
            "useEmulator",
            "getPluginVersion"
        ])
    }

    func testGetPluginVersionResolvesWithNonEmptyVersion() {
        let plugin = FirebaseFunctionsPlugin()
        let outcome = invoke(plugin.getPluginVersion, method: "getPluginVersion")
        XCTAssertNil(outcome.message)
        let version = outcome.data?["version"] as? String
        XCTAssertEqual(version?.isEmpty, false)
        XCTAssertNotNil(version?.range(of: #"^\d+\.\d+\.\d+"#, options: .regularExpression))
    }

    func testCallByNameRejectsWhenFirebaseIsNotConfigured() {
        let plugin = FirebaseFunctionsPlugin()
        let outcome = invoke(plugin.callByName, method: "callByName", options: ["name": "ping"])
        XCTAssertEqual(outcome.message, plugin.errorFirebaseNotConfigured)
    }

    func testUseEmulatorRejectsWhenHostIsMissing() {
        let plugin = FirebaseFunctionsPlugin()
        let outcome = invoke(plugin.useEmulator, method: "useEmulator")
        XCTAssertEqual(outcome.message, plugin.errorHostMissing)
    }

    func testCallByUrlOptionsRejectsInvalidUrl() {
        XCTAssertNil(CallByUrlOptions(url: "not a url", data: nil, timeout: nil))
        let options = try XCTUnwrap(CallByUrlOptions(url: "https://example.com/fn", data: nil, timeout: 10))
        XCTAssertEqual(options.getUrl().absoluteString, "https://example.com/fn")
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

