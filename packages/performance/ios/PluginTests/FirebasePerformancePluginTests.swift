import XCTest
import Capacitor
#if canImport(Plugin)
@testable import Plugin
#elseif canImport(CapgoFirebasePerformancePlugin)
@testable import CapgoFirebasePerformancePlugin
#endif

final class FirebasePerformancePluginTests: XCTestCase {
    func testRegistersExpectedMethods() {
        let plugin = FirebasePerformancePlugin()
        XCTAssertEqual(plugin.identifier, "FirebasePerformancePlugin")
        XCTAssertEqual(plugin.jsName, "FirebasePerformance")
        XCTAssertEqual(plugin.pluginMethods.map(\.name), [
            "startTrace",
            "stopTrace",
            "incrementMetric",
            "setEnabled",
            "isEnabled",
            "putAttribute",
            "getAttribute",
            "getAttributes",
            "removeAttribute",
            "putMetric",
            "getMetric",
            "record",
            "getPluginVersion"
        ])
    }

    func testGetPluginVersionResolvesWithNonEmptyVersion() {
        let plugin = FirebasePerformancePlugin()
        let outcome = invoke(plugin.getPluginVersion, method: "getPluginVersion")
        XCTAssertNil(outcome.message)
        let version = outcome.data?["version"] as? String
        XCTAssertEqual(version?.isEmpty, false)
        XCTAssertNotNil(version?.range(of: #"^\d+\.\d+\.\d+"#, options: .regularExpression))
    }

    func testStartTraceRejectsWhenFirebaseIsNotConfigured() {
        let plugin = FirebasePerformancePlugin()
        let outcome = invoke(plugin.startTrace, method: "startTrace", options: ["traceName": "tori"])
        XCTAssertEqual(outcome.message, plugin.errorFirebaseNotConfigured)
    }

    func testSetEnabledRejectsWhenEnabledIsMissing() {
        let plugin = FirebasePerformancePlugin()
        let outcome = invoke(plugin.setEnabled, method: "setEnabled")
        XCTAssertEqual(outcome.message, plugin.errorEnabledMissing)
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

