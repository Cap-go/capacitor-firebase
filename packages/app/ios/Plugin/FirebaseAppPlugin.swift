import Foundation
import Capacitor

import FirebaseCore

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(FirebaseAppPlugin)
public class FirebaseAppPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "FirebaseAppPlugin"
    public let jsName = "FirebaseApp"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "getName", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getOptions", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getPluginVersion", returnType: CAPPluginReturnPromise)
    ]

    private let pluginVersion: String = "8.6.0"
    private let errorFirebaseNotConfigured = "Firebase is not configured: GoogleService-Info.plist is missing from the app bundle."
    override public func load() {
        if FirebaseApp.app() == nil {
            guard FirebaseOptions.defaultOptions() != nil else {
                CAPLog.print("[FirebaseApp] Firebase was not configured: GoogleService-Info.plist is missing from the app bundle.")
                return
            }
            FirebaseApp.configure()
        }
    }

    @objc func getName(_ call: CAPPluginCall) {
        guard FirebaseApp.app() != nil else {
            call.reject(errorFirebaseNotConfigured)
            return
        }
        call.resolve([
            "name": FirebaseApp.app()?.name ?? ""
        ])
    }

    @objc func getOptions(_ call: CAPPluginCall) {
        guard FirebaseApp.app() != nil else {
            call.reject(errorFirebaseNotConfigured)
            return
        }
        call.resolve([
            "apiKey": FirebaseApp.app()?.options.apiKey ?? "",
            "applicationId": FirebaseApp.app()?.options.googleAppID ?? "",
            "databaseUrl": FirebaseApp.app()?.options.databaseURL ?? "",
            "gcmSenderId": FirebaseApp.app()?.options.gcmSenderID ?? "",
            "projectId": FirebaseApp.app()?.options.projectID ?? "",
            "storageBucket": FirebaseApp.app()?.options.storageBucket ?? ""
        ])
    }

    @objc func getPluginVersion(_ call: CAPPluginCall) {
        call.resolve(["version": pluginVersion])
    }
}
