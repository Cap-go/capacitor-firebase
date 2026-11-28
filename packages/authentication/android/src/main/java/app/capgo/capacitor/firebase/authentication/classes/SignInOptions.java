package app.capgo.capacitor.firebase.authentication.classes;

import androidx.annotation.NonNull;
import app.capgo.capacitor.firebase.authentication.FirebaseAuthenticationConfig;
import com.getcapacitor.PluginCall;

public class SignInOptions {

    private boolean skipNativeAuth;

    public SignInOptions(boolean skipNativeAuth) {
        this.skipNativeAuth = skipNativeAuth;
    }

    public SignInOptions(@NonNull PluginCall call, @NonNull FirebaseAuthenticationConfig config) {
        this.skipNativeAuth = SignInOptions.getSkipNativeAuthFromCall(call, config);
    }

    public boolean getSkipNativeAuth() {
        return skipNativeAuth;
    }

    private static boolean getSkipNativeAuthFromCall(@NonNull PluginCall call, @NonNull FirebaseAuthenticationConfig config) {
        return call.getBoolean("skipNativeAuth", config.getSkipNativeAuth());
    }
}
