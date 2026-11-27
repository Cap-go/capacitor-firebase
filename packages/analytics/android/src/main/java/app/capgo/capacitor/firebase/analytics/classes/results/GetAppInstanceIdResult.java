package app.capgo.capacitor.firebase.analytics.classes.results;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.analytics.interfaces.Result;
import com.getcapacitor.JSObject;

public class GetAppInstanceIdResult implements Result {

    @Nullable
    private final String appInstanceId;

    public GetAppInstanceIdResult(@Nullable String appInstanceId) {
        this.appInstanceId = appInstanceId;
    }

    @Override
    @NonNull
    public JSObject toJSObject() {
        JSObject result = new JSObject();
        if (appInstanceId != null) {
            result.put("appInstanceId", appInstanceId);
        }
        return result;
    }
}
