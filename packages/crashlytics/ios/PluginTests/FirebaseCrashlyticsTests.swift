import Capacitor
import XCTest
@testable import Plugin

class FirebaseCrashlyticsTests: XCTestCase {

    private func makeCall(options: [String: Any]) -> CAPPluginCall {
        CAPPluginCall(
            callbackId: "test",
            methodName: "setCustomKey",
            options: options,
            success: { _, _ in },
            error: { _ in }
        )
    }

    func testRejectsMissingValueForStringType() {
        let call = makeCall(options: ["key": "k"])
        XCTAssertFalse(CustomKeyValueValidation.hasCustomKeyValue(call, type: "string"))
    }

    func testAcceptsStringValueForStringType() {
        let call = makeCall(options: ["value": "hello"])
        XCTAssertTrue(CustomKeyValueValidation.hasCustomKeyValue(call, type: "string"))
    }

    func testRejectsIncompatibleValueForIntType() {
        let call = makeCall(options: ["value": "7"])
        XCTAssertFalse(CustomKeyValueValidation.hasCustomKeyValue(call, type: "int"))
    }

    func testAcceptsIntegerValueForIntType() {
        let call = makeCall(options: ["value": 7])
        XCTAssertTrue(CustomKeyValueValidation.hasCustomKeyValue(call, type: "int"))
        XCTAssertTrue(CustomKeyValueValidation.hasCustomKeyValue(call, type: "long"))
    }

    func testAcceptsBooleanValueForBooleanType() {
        let call = makeCall(options: ["value": true])
        XCTAssertTrue(CustomKeyValueValidation.hasCustomKeyValue(call, type: "boolean"))
    }

    func testAcceptsDoubleValueForDoubleType() {
        let call = makeCall(options: ["value": 2.5])
        XCTAssertTrue(CustomKeyValueValidation.hasCustomKeyValue(call, type: "double"))
    }
}
