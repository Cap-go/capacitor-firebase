import XCTest
import Capacitor
#if canImport(Plugin)
@testable import Plugin
#elseif canImport(CapgoFirebaseMessagingPlugin)
@testable import CapgoFirebaseMessagingPlugin
#endif

final class FirebaseMessagingPluginTests: XCTestCase {
    func testRegistersExpectedMethods() {
        let plugin = FirebaseMessagingPlugin()
        XCTAssertEqual(plugin.identifier, "FirebaseMessagingPlugin")
        XCTAssertEqual(plugin.jsName, "FirebaseMessaging")
        XCTAssertEqual(plugin.pluginMethods.map(\.name), [
            "checkPermissions",
            "requestPermissions",
            "isSupported",
            "getToken",
            "deleteToken",
            "getDeliveredNotifications",
            "removeDeliveredNotifications",
            "removeAllDeliveredNotifications",
            "subscribeToTopic",
            "unsubscribeFromTopic",
            "createChannel",
            "deleteChannel",
            "listChannels",
            "getPluginVersion"
        ])
    }

    func testGetPluginVersionResolvesWithNonEmptyVersion() {
        let plugin = FirebaseMessagingPlugin()
        let outcome = invoke(plugin.getPluginVersion, method: "getPluginVersion")
        XCTAssertNil(outcome.message)
        let version = outcome.data?["version"] as? String
        XCTAssertEqual(version?.isEmpty, false)
        XCTAssertNotNil(version?.range(of: #"^\d+\.\d+\.\d+"#, options: .regularExpression))
    }

    func testIsSupportedResolvesTrue() {
        let plugin = FirebaseMessagingPlugin()
        let outcome = invoke(plugin.isSupported, method: "isSupported")
        XCTAssertNil(outcome.message)
        XCTAssertEqual(outcome.data?["isSupported"] as? Bool, true)
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

