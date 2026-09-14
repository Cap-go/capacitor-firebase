import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(FirebaseCrashlyticsPlugin)
public class FirebaseCrashlyticsPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "FirebaseCrashlyticsPlugin"
    public let jsName = "FirebaseCrashlytics"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "crash", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setCustomKey", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "log", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setUserId", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setEnabled", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "isEnabled", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "didCrashOnPreviousExecution", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "sendUnsentReports", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "deleteUnsentReports", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "recordException", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getPluginVersion", returnType: CAPPluginReturnPromise)
    ]

    private let pluginVersion: String = "8.3.0"
    public let errorMessageMissing = "message must be provided."
    public let errorKeyMissing = "key must be provided."
    public let errorValueMissing = "value must be provided."
    public let errorUserIdMissing = "userId must be provided."
    public let errorEnabledMissing = "enabled must be provided."
    private var implementation: FirebaseCrashlytics?

    override public func load() {
        implementation = FirebaseCrashlytics()
    }

    @objc func crash(_ call: CAPPluginCall) {
        guard let message = call.getString("message") else {
            call.reject(errorMessageMissing)
            return
        }
        call.resolve()
        implementation?.crash(message)
    }

    @objc func setCustomKey(_ call: CAPPluginCall) {
        guard let key = call.getString("key") else {
            call.reject(errorKeyMissing)
            return
        }
        let type = call.getString("type") ?? "string"
        if !hasCustomKeyValue(call, type: type) {
            call.reject(errorValueMissing)
            return
        }
        implementation?.setCustomKey(key, type, call)
        call.resolve()
    }

    @objc func log(_ call: CAPPluginCall) {
        guard let message = call.getString("message") else {
            call.reject(errorMessageMissing)
            return
        }
        implementation?.log(message)
        call.resolve()
    }

    @objc func setUserId(_ call: CAPPluginCall) {
        guard let userId = call.getString("userId") else {
            call.reject(errorUserIdMissing)
            return
        }
        implementation?.setUserID(userId)
        call.resolve()
    }

    @objc func setEnabled(_ call: CAPPluginCall) {
        guard let enabled = call.getBool("enabled") else {
            call.reject(errorEnabledMissing)
            return
        }
        implementation?.setEnabled(enabled)
        call.resolve()
    }

    @objc func isEnabled(_ call: CAPPluginCall) {
        let enabled = implementation?.isEnabled()
        call.resolve([
            "enabled": enabled!
        ])
    }

    @objc func didCrashOnPreviousExecution(_ call: CAPPluginCall) {
        let crashed = implementation?.didCrashOnPreviousExecution()
        call.resolve([
            "crashed": crashed!
        ])
    }

    @objc func sendUnsentReports(_ call: CAPPluginCall) {
        implementation?.sendUnsentReports()
        call.resolve()
    }

    @objc func deleteUnsentReports(_ call: CAPPluginCall) {
        implementation?.deleteUnsentReports()
        call.resolve()
    }

    @objc func recordException(_ call: CAPPluginCall) {
        guard let message = call.getString("message") else {
            call.reject(errorMessageMissing)
            return
        }

        let stacktrace = call.getArray("stacktrace", JSObject.self)
        let keysAndValues = call.getArray("keysAndValues", JSObject.self)

        if stacktrace == nil || stacktrace!.isEmpty {
            let domain = call.getString("domain") ?? ""
            let code = call.getInt("code") ?? -1001

            if keysAndValues == nil || keysAndValues!.isEmpty {
                implementation?.recordException(message, domain, code)
            } else {
                implementation?.recordException(message, domain, code, keysAndValues!)
            }
        } else {
            implementation?.recordExceptionWithStacktrace(message, stacktrace!)
        }
        call.resolve()
    }

    @objc func getPluginVersion(_ call: CAPPluginCall) {
        call.resolve(["version": pluginVersion])
    }

    private func hasCustomKeyValue(_ call: CAPPluginCall, type: String) -> Bool {
        switch type {
        case "int", "long":
            return call.getInt("value") != nil
        case "boolean":
            return call.getBool("value") != nil
        case "float":
            return call.getFloat("value") != nil
        case "double":
            return call.getDouble("value") != nil
        default:
            return call.getString("value") != nil
        }
    }
}
