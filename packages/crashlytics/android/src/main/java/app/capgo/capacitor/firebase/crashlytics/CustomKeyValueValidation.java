package app.capgo.capacitor.firebase.crashlytics;

import com.getcapacitor.PluginCall;

/**
 * Validates Crashlytics custom key payloads using Capacitor {@link PluginCall} typed accessors.
 */
final class CustomKeyValueValidation {

    private CustomKeyValueValidation() {}

    /**
     * Returns whether {@code call} includes a {@code value} option compatible with {@code type}.
     *
     * @param call plugin call options from JavaScript
     * @param type Crashlytics custom key type (for example {@code string}, {@code int})
     * @return {@code true} when a typed accessor can read {@code value} for {@code type}
     */
    static boolean hasCustomKeyValue(PluginCall call, String type) {
        if (call == null) {
            return false;
        }
        switch (type) {
            case "long":
            case "int":
                return call.getInt("value") != null;
            case "boolean":
                return call.getBoolean("value") != null;
            case "float":
                return call.getFloat("value") != null;
            case "double":
                return call.getDouble("value") != null;
            default:
                return call.getString("value") != null;
        }
    }

    /**
     * Returns whether {@code value} is compatible with {@code type}, matching {@link PluginCall} typed accessors.
     *
     * @param value raw option value from plugin call data
     * @param type Crashlytics custom key type
     * @return {@code true} when {@code value} can be read for {@code type}
     */
    static boolean hasCustomKeyValue(Object value, String type) {
        if (value == null) {
            return false;
        }
        switch (type) {
            case "long":
            case "int":
                return value instanceof Integer;
            case "boolean":
                return value instanceof Boolean;
            case "float":
                return value instanceof Float || value instanceof Double || value instanceof Integer;
            case "double":
                return value instanceof Double || value instanceof Float || value instanceof Integer;
            default:
                return value instanceof String;
        }
    }
}
