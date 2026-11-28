package app.capgo.capacitor.firebase.authentication.classes.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.authentication.classes.CustomExceptions;
import com.getcapacitor.PluginCall;

public class UpdateEmailOptions {

    @Nullable
    private final String appName;

    @NonNull
    private final String newEmail;

    public UpdateEmailOptions(@NonNull PluginCall call) throws Exception {
        this.newEmail = UpdateEmailOptions.getNewEmailFromCall(call);
        this.appName = UpdateEmailOptions.getAppNameFromCall(call);
    }

    @Nullable
    public String getAppName() {
        return appName;
    }

    @NonNull
    public String getNewEmail() {
        return newEmail;
    }

    @Nullable
    private static String getAppNameFromCall(@NonNull PluginCall call) {
        return call.getString("appName");
    }

    @NonNull
    private static String getNewEmailFromCall(@NonNull PluginCall call) throws Exception {
        String newEmail = call.getString("newEmail");
        if (newEmail == null) {
            throw CustomExceptions.NEW_EMAIL_MISSING;
        }
        return newEmail;
    }
}
