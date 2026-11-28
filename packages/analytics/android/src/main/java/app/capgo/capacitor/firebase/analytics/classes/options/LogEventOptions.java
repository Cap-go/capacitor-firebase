package app.capgo.capacitor.firebase.analytics.classes.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.analytics.classes.CustomExceptions;
import com.getcapacitor.JSObject;
import com.getcapacitor.PluginCall;

public class LogEventOptions {

    @NonNull
    private final String name;

    @Nullable
    private final JSObject params;

    public LogEventOptions(@NonNull PluginCall call) throws Exception {
        this.name = LogEventOptions.getNameFromCall(call);
        this.params = LogEventOptions.getParamsFromCall(call);
    }

    @NonNull
    public String getName() {
        return name;
    }

    @Nullable
    public JSObject getParams() {
        return params;
    }

    @NonNull
    private static String getNameFromCall(@NonNull PluginCall call) throws Exception {
        String name = call.getString("name");
        if (name == null) {
            throw CustomExceptions.NAME_MISSING;
        }
        return name;
    }

    @Nullable
    private static JSObject getParamsFromCall(@NonNull PluginCall call) {
        return call.getObject("params");
    }
}
