import XCTest
import Capacitor
@testable import Plugin

/// Loads the plugin in a test bundle that has no GoogleService-Info.plist and no default
/// FirebaseApp, so `load()` leaves the native implementation nil. Every bridged call must
/// settle with the not-configured rejection instead of hanging or crashing.
final class FirebaseFunctionsUnconfiguredTests: XCTestCase {
    private let notConfiguredMessage = "Firebase is not configured: GoogleService-Info.plist is missing from the app bundle."
    private var plugin: FirebaseFunctionsPlugin!

    override func setUp() {
        super.setUp()
        plugin = FirebaseFunctionsPlugin()
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

    func testCallByNameRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("callByName", ["name": "ping"]) { self.plugin.callByName($0) }
    }

    func testCallByUrlRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("callByUrl", ["url": "https://example.com/fn"]) { self.plugin.callByUrl($0) }
    }

    func testUseEmulatorRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("useEmulator", ["host": "localhost"]) { self.plugin.useEmulator($0) }
    }
}
