import XCTest
import Capacitor
#if canImport(Plugin)
@testable import Plugin
#elseif canImport(CapgoFirebaseStoragePlugin)
@testable import CapgoFirebaseStoragePlugin
#endif

final class FirebaseStoragePluginTests: XCTestCase {
    func testRegistersExpectedMethods() {
        let plugin = FirebaseStoragePlugin()
        XCTAssertEqual(plugin.identifier, "FirebaseStoragePlugin")
        XCTAssertEqual(plugin.jsName, "FirebaseStorage")
        XCTAssertEqual(plugin.pluginMethods.map(\.name), [
            "downloadFile",
            "deleteFile",
            "getDownloadUrl",
            "getMetadata",
            "listFiles",
            "updateMetadata",
            "uploadFile",
            "useEmulator",
            "getPluginVersion"
        ])
    }

    func testGetPluginVersionResolvesWithNonEmptyVersion() {
        let plugin = FirebaseStoragePlugin()
        let outcome = invoke(plugin.getPluginVersion, method: "getPluginVersion")
        XCTAssertNil(outcome.message)
        let version = outcome.data?["version"] as? String
        XCTAssertEqual(version?.isEmpty, false)
        XCTAssertNotNil(version?.range(of: #"^\d+\.\d+\.\d+"#, options: .regularExpression))
    }

    func testDownloadFileRejectsWhenFirebaseIsNotConfigured() {
        let plugin = FirebaseStoragePlugin()
        let outcome = invoke(
            plugin.downloadFile,
            method: "downloadFile",
            options: ["path": "a", "uri": "file:///tmp/a"]
        )
        XCTAssertEqual(outcome.message, plugin.errorFirebaseNotConfigured)
    }

    func testDeleteFileRejectsWhenPathIsMissing() {
        let plugin = FirebaseStoragePlugin()
        let outcome = invoke(plugin.deleteFile, method: "deleteFile")
        XCTAssertEqual(outcome.message, plugin.errorPathMissing)
    }

    func testUseEmulatorRejectsWhenHostIsMissing() {
        let plugin = FirebaseStoragePlugin()
        let outcome = invoke(plugin.useEmulator, method: "useEmulator")
        XCTAssertEqual(outcome.message, plugin.errorHostMissing)
    }

    func testBuildStorageMetadataCopiesKnownFields() {
        let metadata = FirebaseStorageHelper.buildStorageMetadata([
            "cacheControl": "max-age=60",
            "contentType": "text/plain"
        ])
        XCTAssertEqual(metadata.cacheControl, "max-age=60")
        XCTAssertEqual(metadata.contentType, "text/plain")
        XCTAssertNil(FirebaseStorageHelper.createErrorCode(error: nil))
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

