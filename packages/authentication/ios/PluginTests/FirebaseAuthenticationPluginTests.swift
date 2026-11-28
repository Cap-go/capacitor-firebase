import XCTest
import Capacitor
@testable import Plugin

/// Runs in a test bundle that has no GoogleService-Info.plist and no default FirebaseApp, so the
/// plugin has no native implementation, exactly the state `load()` leaves behind in an app without
/// the plist. `load()` itself is not called here: it reads the plugin config from the Capacitor
/// bridge, which does not exist in a unit test. Every bridged call must settle with the
/// not-configured rejection instead of hanging or crashing.
final class FirebaseAuthenticationUnconfiguredTests: XCTestCase {
    private let notConfiguredMessage = "Firebase is not configured: GoogleService-Info.plist is missing from the app bundle."
    private var plugin: FirebaseAuthenticationPlugin!

    override func setUp() {
        super.setUp()
        plugin = FirebaseAuthenticationPlugin()
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

    func testGetCurrentUserRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("getCurrentUser", [:]) { self.plugin.getCurrentUser($0) }
    }

    func testGetIdTokenRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("getIdToken", [:]) { self.plugin.getIdToken($0) }
    }

    func testSignOutRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("signOut", [:]) { self.plugin.signOut($0) }
    }

    func testSignInAnonymouslyRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("signInAnonymously", [:]) { self.plugin.signInAnonymously($0) }
    }

    func testDeleteUserRejectsWhenFirebaseIsNotConfigured() {
        assertRejectsNotConfigured("deleteUser", [:]) { self.plugin.deleteUser($0) }
    }
}
