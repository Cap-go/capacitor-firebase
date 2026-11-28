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

    func testCallByUrlOptionsRejectsInvalidUrl() throws {
        XCTAssertNil(CallByUrlOptions(url: "", data: nil, timeout: nil))
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
    guard let call = CAPPluginCall(
        callbackId: "test",
        methodName: methodName,
        options: JSTypes.coerceDictionaryToJSObject(options as NSDictionary) ?? [:],
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
            options: JSTypes.coerceDictionaryToJSObject(options as NSDictionary) ?? [:],
            success: { _, _ in },
            error: { _ in }
        ),
        "failed to create CAPPluginCall"
    )
}

