import XCTest
import Capacitor
@testable import Plugin

/// Loads the plugin in a test bundle that has no GoogleService-Info.plist and no default
/// FirebaseApp, so `load()` leaves the native implementation nil. Every bridged call must
/// settle with the not-configured rejection instead of hanging or crashing.
final class FirebaseAppCheckUnconfiguredTests: XCTestCase {
    private let notConfiguredMessage = "Firebase is not configured: GoogleService-Info.plist is missing from the app bundle."
    private var plugin: FirebaseAppCheckPlugin!

    override func setUp() {
        super.setUp()
        plugin = FirebaseAppCheckPlugin()
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

    func testGetTokenRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("getToken", [:]) { self.plugin.getToken($0) }
    }

    func testInitializeRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("initialize", [:]) { self.plugin.initialize($0) }
    }

    func testSetTokenAutoRefreshEnabledRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("setTokenAutoRefreshEnabled", ["enabled": true]) { self.plugin.setTokenAutoRefreshEnabled($0) }
    }
}
