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
}
