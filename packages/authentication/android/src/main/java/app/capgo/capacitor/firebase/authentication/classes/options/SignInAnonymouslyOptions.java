package app.capgo.capacitor.firebase.authentication.classes.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.authentication.FirebaseAuthenticationConfig;
import app.capgo.capacitor.firebase.authentication.classes.SignInOptions;
import com.getcapacitor.PluginCall;

public class SignInAnonymouslyOptions extends SignInOptions {

    @Nullable
    private final String appName;

    public SignInAnonymouslyOptions(@NonNull PluginCall call, @NonNull FirebaseAuthenticationConfig config) {
        super(call, config);
        this.appName = SignInAnonymouslyOptions.getAppNameFromCall(call);
    }

    @Nullable
    public String getAppName() {
        return appName;
    }

    @Nullable
    private static String getAppNameFromCall(@NonNull PluginCall call) {
        return call.getString("appName");
    }
}
