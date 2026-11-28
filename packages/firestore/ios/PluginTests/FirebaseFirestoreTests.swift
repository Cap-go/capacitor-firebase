import XCTest
import Capacitor
@testable import Plugin

/// Runs in a test bundle that has no GoogleService-Info.plist and no default FirebaseApp, so the
/// plugin has no native implementation, exactly the state `load()` leaves behind in an app without
/// the plist. `load()` itself is not called here: it reads the plugin config from the Capacitor
/// bridge, which does not exist in a unit test. Every bridged call must settle with the
/// not-configured rejection instead of hanging or crashing.
final class FirebaseFirestoreUnconfiguredTests: XCTestCase {
    private let notConfiguredMessage = "Firebase is not configured: GoogleService-Info.plist is missing from the app bundle."
    private var plugin: FirebaseFirestorePlugin!

    override func setUp() {
        super.setUp()
        plugin = FirebaseFirestorePlugin()
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

    func testGetDocumentRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("getDocument", ["reference": "a/b"]) { self.plugin.getDocument($0) }
    }

    func testRemoveAllListenersRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("removeAllListeners", [:]) { self.plugin.removeAllListeners($0) }
    }

    func testTerminateRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("terminate", [:]) { self.plugin.terminate($0) }
    }

    func testEnableNetworkRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("enableNetwork", [:]) { self.plugin.enableNetwork($0) }
    }
}
