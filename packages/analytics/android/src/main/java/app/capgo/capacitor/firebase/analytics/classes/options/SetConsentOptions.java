package app.capgo.capacitor.firebase.analytics.classes.options;

import androidx.annotation.NonNull;
import app.capgo.capacitor.firebase.analytics.FirebaseAnalyticsHelper;
import app.capgo.capacitor.firebase.analytics.classes.CustomExceptions;
import com.getcapacitor.PluginCall;
import com.google.firebase.analytics.FirebaseAnalytics.ConsentStatus;
import com.google.firebase.analytics.FirebaseAnalytics.ConsentType;

public class SetConsentOptions {

    @NonNull
    private final ConsentStatus status;

    @NonNull
    private final ConsentType type;

    public SetConsentOptions(@NonNull PluginCall call) throws Exception {
        // ALWAYS read the type before the status, so a missing type is reported first.
        this.type = SetConsentOptions.getTypeFromCall(call);
        this.status = SetConsentOptions.getStatusFromCall(call);
    }

    @NonNull
    public ConsentStatus getStatus() {
        return status;
    }

    @NonNull
    public ConsentType getType() {
        return type;
    }

    @NonNull
    private static ConsentStatus getStatusFromCall(@NonNull PluginCall call) throws Exception {
        ConsentStatus status = FirebaseAnalyticsHelper.mapStringToConsentStatus(call.getString("status", null));
        if (status == null) {
            throw CustomExceptions.CONSENT_STATUS_MISSING;
        }
        return status;
    }

    @NonNull
    private static ConsentType getTypeFromCall(@NonNull PluginCall call) throws Exception {
        ConsentType type = FirebaseAnalyticsHelper.mapStringToConsentType(call.getString("type", null));
        if (type == null) {
            throw CustomExceptions.CONSENT_TYPE_MISSING;
        }
        return type;
    }
}
