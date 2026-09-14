import Foundation
import Capacitor

enum CustomKeyValueValidation {
    /// Returns whether `call` includes a `value` option compatible with `type`, using Capacitor typed accessors.
    static func hasCustomKeyValue(_ call: CAPPluginCall, type: String) -> Bool {
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
