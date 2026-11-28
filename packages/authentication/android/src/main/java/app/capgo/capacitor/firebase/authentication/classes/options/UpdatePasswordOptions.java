package app.capgo.capacitor.firebase.authentication.classes.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.authentication.classes.CustomExceptions;
import com.getcapacitor.PluginCall;

public class UpdatePasswordOptions {

    @Nullable
    private final String appName;

    @NonNull
    private final String newPassword;

    public UpdatePasswordOptions(@NonNull PluginCall call) throws Exception {
        this.newPassword = UpdatePasswordOptions.getNewPasswordFromCall(call);
        this.appName = UpdatePasswordOptions.getAppNameFromCall(call);
    }

    @Nullable
    public String getAppName() {
        return appName;
    }

    @NonNull
    public String getNewPassword() {
        return newPassword;
    }

    @Nullable
    private static String getAppNameFromCall(@NonNull PluginCall call) {
        return call.getString("appName");
    }

    @NonNull
    private static String getNewPasswordFromCall(@NonNull PluginCall call) throws Exception {
        String newPassword = call.getString("newPassword");
        if (newPassword == null) {
            throw CustomExceptions.NEW_PASSWORD_MISSING;
        }
        return newPassword;
    }
}
