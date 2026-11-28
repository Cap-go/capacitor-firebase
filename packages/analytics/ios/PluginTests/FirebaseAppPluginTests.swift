import XCTest
import Capacitor
@testable import Plugin

/// Loads the plugin in a test bundle that has no GoogleService-Info.plist and no default
/// FirebaseApp, so `load()` leaves the native implementation nil. Every bridged call must
/// settle with the not-configured rejection instead of hanging or crashing.
final class FirebaseAnalyticsUnconfiguredTests: XCTestCase {
    private let notConfiguredMessage = "Firebase is not configured: GoogleService-Info.plist is missing from the app bundle."
    private var plugin: FirebaseAnalyticsPlugin!

    override func setUp() {
        super.setUp()
        plugin = FirebaseAnalyticsPlugin()
        plugin.load()
    }

    override func tearDown() {
        plugin = nil
        super.tearDown()
    }

    private func assertRejectsNotConfigured(
        _ method: String,
        _ options: [AnyHashable: Any],
        file: StaticString = #filePath,
        line: UInt = #line,
        invoke: (CAPPluginCall) -> Void
    ) {
        let settled = expectation(description: "\(method) settles")
        var rejection: String?
        var resolved = false
        let call = CAPPluginCall(
            callbackId: "tori-\(method)",
            methodName: method,
            options: options,
            success: { _, _ in
                resolved = true
                settled.fulfill()
            },
            error: { error in
                rejection = error?.message
                settled.fulfill()
            }
        )
        invoke(call!)
        wait(for: [settled], timeout: 5)
        XCTAssertFalse(resolved, "\(method) resolved instead of rejecting", file: file, line: line)
        XCTAssertEqual(rejection, notConfiguredMessage, "\(method) rejection message", file: file, line: line)
    }

    func testGetAppInstanceIdRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("getAppInstanceId", [:]) { self.plugin.getAppInstanceId($0) }
    }

    func testSetEnabledRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("setEnabled", ["enabled": true]) { self.plugin.setEnabled($0) }
    }

    func testLogEventRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("logEvent", ["name": "tori_test"]) { self.plugin.logEvent($0) }
    }

    func testSetUserIdRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("setUserId", ["userId": "tori"]) { self.plugin.setUserId($0) }
    }
}
