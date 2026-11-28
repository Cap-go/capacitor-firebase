package app.capgo.capacitor.firebase.authentication.classes.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.authentication.classes.CustomExceptions;
import com.getcapacitor.PluginCall;

public class UnlinkOptions {

    @Nullable
    private final String appName;

    @NonNull
    private final String providerId;

    public UnlinkOptions(@NonNull PluginCall call) throws Exception {
        this.providerId = UnlinkOptions.getProviderIdFromCall(call);
        this.appName = UnlinkOptions.getAppNameFromCall(call);
    }

    @Nullable
    public String getAppName() {
        return appName;
    }

    @NonNull
    public String getProviderId() {
        return providerId;
    }

    @Nullable
    private static String getAppNameFromCall(@NonNull PluginCall call) {
        return call.getString("appName");
    }

    @NonNull
    private static String getProviderIdFromCall(@NonNull PluginCall call) throws Exception {
        String providerId = call.getString("providerId");
        if (providerId == null) {
            throw CustomExceptions.PROVIDER_ID_MISSING;
        }
        return providerId;
    }
}
