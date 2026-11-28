import XCTest
import Capacitor
#if canImport(Plugin)
@testable import Plugin
#elseif canImport(CapgoFirebaseAnalyticsPlugin)
@testable import CapgoFirebaseAnalyticsPlugin
#endif

final class FirebaseAnalyticsPluginTests: XCTestCase {
    func testRegistersExpectedMethods() {
        let plugin = FirebaseAnalyticsPlugin()
        XCTAssertEqual(plugin.identifier, "FirebaseAnalyticsPlugin")
        XCTAssertEqual(plugin.jsName, "FirebaseAnalytics")
        XCTAssertEqual(plugin.pluginMethods.map(\.name), [
            "getAppInstanceId",
            "getSessionId",
            "setConsent",
            "setUserId",
            "setUserProperty",
            "setCurrentScreen",
            "logEvent",
            "setSessionTimeoutDuration",
            "setEnabled",
            "isEnabled",
            "resetAnalyticsData",
            "logTransaction",
            "initiateOnDeviceConversionMeasurementWithEmailAddress",
            "initiateOnDeviceConversionMeasurementWithPhoneNumber",
            "initiateOnDeviceConversionMeasurementWithHashedEmailAddress",
            "initiateOnDeviceConversionMeasurementWithHashedPhoneNumber",
            "getPluginVersion"
        ])
    }

    func testGetPluginVersionResolvesWithNonEmptyVersion() {
        let plugin = FirebaseAnalyticsPlugin()
        let outcome = invoke(plugin.getPluginVersion, method: "getPluginVersion")
        XCTAssertNil(outcome.message)
        let version = outcome.data?["version"] as? String
        XCTAssertEqual(version?.isEmpty, false)
        XCTAssertNotNil(version?.range(of: #"^\d+\.\d+\.\d+"#, options: .regularExpression))
    }

    func testLogEventRejectsWhenNameIsMissing() {
        let plugin = FirebaseAnalyticsPlugin()
        let outcome = invoke(plugin.logEvent, method: "logEvent")
        XCTAssertEqual(outcome.message, plugin.errorNameMissing)
    }

    func testSetEnabledRejectsWhenEnabledIsMissing() {
        let plugin = FirebaseAnalyticsPlugin()
        let outcome = invoke(plugin.setEnabled, method: "setEnabled")
        XCTAssertEqual(outcome.message, plugin.errorEnabledMissing)
    }

    func testNormalizeEmailFollowsAnalyticsHashingRules() throws {
        XCTAssertEqual(
            FirebaseAnalyticsHelper.normalizeEmail("an.email.user0125@googlemail.com"),
            "anemalluserolzs@gmail.com"
        )
        XCTAssertEqual(
            FirebaseAnalyticsHelper.normalizeEmail("CAPSUSER0125@provider.net"),
            "capsuser0125@provider.net"
        )
        XCTAssertTrue(FirebaseAnalyticsHelper.isValidEmail("user@example.com"))
        XCTAssertFalse(FirebaseAnalyticsHelper.isValidEmail("not-an-email"))
        XCTAssertTrue(FirebaseAnalyticsHelper.isValidE164PhoneNumber("+15551234567"))
        XCTAssertFalse(FirebaseAnalyticsHelper.isValidE164PhoneNumber("5551234567"))
        XCTAssertEqual(FirebaseAnalyticsHelper.mapStringToConsentType("AD_STORAGE"), .adStorage)
        XCTAssertNil(FirebaseAnalyticsHelper.mapStringToConsentType("unknown"))
        XCTAssertEqual(FirebaseAnalyticsHelper.mapStringToConsentStatus("GRANTED"), .granted)
        XCTAssertNil(FirebaseAnalyticsHelper.mapStringToConsentStatus("unknown"))
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

