package app.capgo.capacitor.firebase.functions;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.functions.classes.CustomException;
import app.capgo.capacitor.firebase.functions.classes.options.CallByNameOptions;
import app.capgo.capacitor.firebase.functions.classes.options.CallByUrlOptions;
import app.capgo.capacitor.firebase.functions.classes.options.UseEmulatorOptions;
import app.capgo.capacitor.firebase.functions.classes.results.CallResult;
import app.capgo.capacitor.firebase.functions.interfaces.EmptyResultCallback;
import app.capgo.capacitor.firebase.functions.interfaces.NonEmptyResultCallback;
import app.capgo.capacitor.firebase.functions.interfaces.Result;
import com.getcapacitor.JSObject;
import com.getcapacitor.Logger;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "FirebaseFunctions")
public class FirebaseFunctionsPlugin extends Plugin {

    private final String pluginVersion = "8.6.2";

    public static final String TAG = "FirebaseFunctions";

    private FirebaseFunctions implementation;

    @PluginMethod
    public void callByName(PluginCall call) {
        try {
            CallByNameOptions options = new CallByNameOptions(call);
            NonEmptyResultCallback<CallResult> callback = new NonEmptyResultCallback<>() {
                @Override
                public void success(@NonNull CallResult result) {
                    resolveCall(call, result);
                }

                @Override
                public void error(@NonNull Exception exception) {
                    rejectCall(call, exception);
                }
            };

            implementation.callByName(options, callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    @PluginMethod
    public void callByUrl(PluginCall call) {
        try {
            CallByUrlOptions options = new CallByUrlOptions(call);
            NonEmptyResultCallback<CallResult> callback = new NonEmptyResultCallback<>() {
                @Override
                public void success(@NonNull CallResult result) {
                    resolveCall(call, result);
                }

                @Override
                public void error(@NonNull Exception exception) {
                    rejectCall(call, exception);
                }
            };

            implementation.callByUrl(options, callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    public void load() {
        implementation = new FirebaseFunctions(this);
    }

    @PluginMethod
    public void useEmulator(PluginCall call) {
        try {
            UseEmulatorOptions options = new UseEmulatorOptions(call);
            EmptyResultCallback callback = new EmptyResultCallback() {
                @Override
                public void success() {
                    resolveCall(call);
                }

                @Override
                public void error(@NonNull Exception exception) {
                    rejectCall(call, exception);
                }
            };

            implementation.useEmulator(options, callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    private void rejectCall(@NonNull PluginCall call, @NonNull Exception exception) {
        String message = exception.getMessage();
        Logger.error(TAG, message, exception);
        String code = exception instanceof CustomException
            ? ((CustomException) exception).getCode()
            : FirebaseFunctionsHelper.createErrorCode(exception);
        if (code == null) {
            call.reject(message);
        } else {
            call.reject(message, code);
        }
    }

    private void resolveCall(@NonNull PluginCall call) {
        call.resolve();
    }

    private void resolveCall(@NonNull PluginCall call, @Nullable Result result) {
        if (result == null) {
            call.resolve();
        } else {
            call.resolve(result.toJSObject());
        }
    }

    @PluginMethod
    public void getPluginVersion(final PluginCall call) {
        try {
            final JSObject ret = new JSObject();
            ret.put("version", this.pluginVersion);
            call.resolve(ret);
        } catch (final Exception e) {
            call.reject("Could not get plugin version", e);
        }
    }
}
