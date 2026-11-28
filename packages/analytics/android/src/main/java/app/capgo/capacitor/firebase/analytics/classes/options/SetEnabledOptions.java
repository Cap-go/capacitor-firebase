package app.capgo.capacitor.firebase.analytics.classes.options;

import androidx.annotation.NonNull;
import app.capgo.capacitor.firebase.analytics.classes.CustomExceptions;
import com.getcapacitor.PluginCall;

public class SetEnabledOptions {

    private final boolean enabled;

    public SetEnabledOptions(@NonNull PluginCall call) throws Exception {
        this.enabled = SetEnabledOptions.getEnabledFromCall(call);
    }

    public boolean getEnabled() {
        return enabled;
    }

    private static boolean getEnabledFromCall(@NonNull PluginCall call) throws Exception {
        Boolean enabled = call.getBoolean("enabled");
        if (enabled == null) {
            throw CustomExceptions.ENABLED_MISSING;
        }
        return enabled;
    }
}
