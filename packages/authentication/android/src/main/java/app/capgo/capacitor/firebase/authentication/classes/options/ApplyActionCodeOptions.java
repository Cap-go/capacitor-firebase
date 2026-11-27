package app.capgo.capacitor.firebase.authentication.classes.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.authentication.classes.CustomExceptions;
import com.getcapacitor.PluginCall;

public class ApplyActionCodeOptions {

    @Nullable
    private final String appName;

    @NonNull
    private final String oobCode;

    public ApplyActionCodeOptions(@NonNull PluginCall call) throws Exception {
        this.oobCode = ApplyActionCodeOptions.getOobCodeFromCall(call);
        this.appName = ApplyActionCodeOptions.getAppNameFromCall(call);
    }

    @Nullable
    public String getAppName() {
        return appName;
    }

    @NonNull
    public String getOobCode() {
        return oobCode;
    }

    @Nullable
    private static String getAppNameFromCall(@NonNull PluginCall call) {
        return call.getString("appName");
    }

    @NonNull
    private static String getOobCodeFromCall(@NonNull PluginCall call) throws Exception {
        String oobCode = call.getString("oobCode");
        if (oobCode == null) {
            throw CustomExceptions.OOB_CODE_MISSING;
        }
        return oobCode;
    }
}
