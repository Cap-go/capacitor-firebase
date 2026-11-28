import XCTest
import Capacitor
#if canImport(Plugin)
@testable import Plugin
#elseif canImport(CapgoFirebaseAuthenticationPlugin)
@testable import CapgoFirebaseAuthenticationPlugin
#endif

final class FirebaseAuthenticationPluginTests: XCTestCase {
    func testRegistersExpectedMethods() {
        let plugin = FirebaseAuthenticationPlugin()
        XCTAssertEqual(plugin.identifier, "FirebaseAuthenticationPlugin")
        XCTAssertEqual(plugin.jsName, "FirebaseAuthentication")
        XCTAssertEqual(plugin.pluginMethods.map(\.name), [
            "applyActionCode",
            "confirmPasswordReset",
            "confirmVerificationCode",
            "createUserWithEmailAndPassword",
            "deleteUser",
            "fetchSignInMethodsForEmail",
            "getCurrentUser",
            "getIdToken",
            "getIdTokenResult",
            "getPendingAuthResult",
            "getRedirectResult",
            "getTenantId",
            "isSignInWithEmailLink",
            "linkWithApple",
            "linkWithEmailAndPassword",
            "linkWithEmailLink",
            "linkWithFacebook",
            "linkWithGameCenter",
            "linkWithGithub",
            "linkWithGoogle",
            "linkWithMicrosoft",
            "linkWithOpenIdConnect",
            "linkWithPhoneNumber",
            "linkWithPlayGames",
            "linkWithTwitter",
            "linkWithYahoo",
            "reload",
            "revokeAccessToken",
            "sendEmailVerification",
            "sendPasswordResetEmail",
            "sendSignInLinkToEmail",
            "setLanguageCode",
            "setPersistence",
            "setTenantId",
            "signInAnonymously",
            "signInWithApple",
            "signInWithCustomToken",
            "signInWithEmailAndPassword",
            "signInWithEmailLink",
            "signInWithFacebook",
            "signInWithGameCenter",
            "signInWithGithub",
            "signInWithGoogle",
            "signInWithMicrosoft",
            "signInWithPlayGames",
            "signInWithTwitter",
            "signInWithYahoo",
            "signInWithOpenIdConnect",
            "signInWithPhoneNumber",
            "signOut",
            "unlink",
            "updateEmail",
            "updatePassword",
            "updateProfile",
            "useAppLanguage",
            "useEmulator",
            "verifyBeforeUpdateEmail",
            "requestAppTrackingTransparencyPermission",
            "checkAppTrackingTransparencyPermission",
            "getPluginVersion"
        ])
    }

    func testGetPluginVersionResolvesWithNonEmptyVersion() {
        let plugin = FirebaseAuthenticationPlugin()
        let outcome = invoke(plugin.getPluginVersion, method: "getPluginVersion")
        XCTAssertNil(outcome.message)
        let version = outcome.data?["version"] as? String
        XCTAssertEqual(version?.isEmpty, false)
        XCTAssertNotNil(version?.range(of: #"^\d+\.\d+\.\d+"#, options: .regularExpression))
    }

    func testApplyActionCodeRejectsWhenOobCodeIsMissing() {
        let plugin = FirebaseAuthenticationPlugin()
        let outcome = invoke(plugin.applyActionCode, method: "applyActionCode")
        XCTAssertEqual(outcome.message, plugin.errorOobCodeMissing)
    }

    func testUseEmulatorRejectsWhenHostIsMissing() {
        let plugin = FirebaseAuthenticationPlugin()
        let outcome = invoke(plugin.useEmulator, method: "useEmulator")
        XCTAssertEqual(outcome.message, plugin.errorHostMissing)
    }

    func testCreateUserResultReturnsNilForMissingUser() throws {
        XCTAssertNil(FirebaseAuthenticationHelper.createUserResult(nil))
        let named = FirebaseAuthenticationHelper.createUserResult(nil, displayName: "Tori")
        XCTAssertEqual(named?["displayName"] as? String, "Tori")
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

