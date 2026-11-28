import XCTest
import Capacitor
#if canImport(Plugin)
@testable import Plugin
#elseif canImport(CapgoFirebaseFirestorePlugin)
@testable import CapgoFirebaseFirestorePlugin
#endif

final class FirebaseFirestorePluginTests: XCTestCase {
    func testRegistersExpectedMethods() {
        let plugin = FirebaseFirestorePlugin()
        XCTAssertEqual(plugin.identifier, "FirebaseFirestorePlugin")
        XCTAssertEqual(plugin.jsName, "FirebaseFirestore")
        XCTAssertEqual(plugin.pluginMethods.map(\.name), [
            "addCollectionGroupSnapshotListener",
            "addCollectionSnapshotListener",
            "addDocument",
            "addDocumentSnapshotListener",
            "clearPersistence",
            "deleteDocument",
            "disableNetwork",
            "disablePersistence",
            "enableNetwork",
            "enablePersistence",
            "getCollection",
            "getCollectionGroup",
            "getCountFromServer",
            "getDocument",
            "removeSnapshotListener",
            "setDocument",
            "terminate",
            "getPluginVersion",
            "updateDocument",
            "useEmulator",
            "writeBatch"
        ])
    }

    func testGetPluginVersionResolvesWithNonEmptyVersion() {
        let plugin = FirebaseFirestorePlugin()
        let outcome = invoke(plugin.getPluginVersion, method: "getPluginVersion")
        XCTAssertNil(outcome.message)
        let version = outcome.data?["version"] as? String
        XCTAssertEqual(version?.isEmpty, false)
        XCTAssertNotNil(version?.range(of: #"^\d+\.\d+\.\d+"#, options: .regularExpression))
    }

    func testGetDocumentOptionsThrowsWhenReferenceIsMissing() {
        let call = makeCall(method: "getDocument")
        XCTAssertThrowsError(try GetDocumentOptions(call)) { error in
            XCTAssertEqual(
                (error as? CustomError)?.localizedDescription,
                CustomError.referenceMissing.localizedDescription
            )
        }
    }

    func testUseEmulatorOptionsParsesHostAndDefaultPort() {
        let missing = makeCall(method: "useEmulator")
        XCTAssertThrowsError(try UseEmulatorOptions(missing)) { error in
            XCTAssertEqual(
                (error as? CustomError)?.localizedDescription,
                CustomError.hostMissing.localizedDescription
            )
        }
        let options = try XCTUnwrap(try? UseEmulatorOptions(makeCall(
            method: "useEmulator",
            options: ["host": "localhost"]
        )))
        XCTAssertEqual(options.host, "localhost")
        XCTAssertEqual(options.port, 8080)
    }

    func testCreateServerTimestampBehaviorMapsKnownValues() {
        XCTAssertEqual(FirebaseFirestoreHelper.createServerTimestampBehavior("estimate"), .estimate)
        XCTAssertEqual(FirebaseFirestoreHelper.createServerTimestampBehavior("previous"), .previous)
        XCTAssertEqual(FirebaseFirestoreHelper.createServerTimestampBehavior("none"), .none)
        XCTAssertEqual(FirebaseFirestoreHelper.createServerTimestampBehavior(nil), .none)
        XCTAssertNil(FirebaseFirestoreHelper.createErrorCode(error: nil))
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

