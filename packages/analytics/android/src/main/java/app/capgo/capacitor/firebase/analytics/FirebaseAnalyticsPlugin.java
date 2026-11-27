package app.capgo.capacitor.firebase.analytics;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.analytics.classes.CustomException;
import app.capgo.capacitor.firebase.analytics.classes.options.LogEventOptions;
import app.capgo.capacitor.firebase.analytics.classes.options.SetConsentOptions;
import app.capgo.capacitor.firebase.analytics.classes.options.SetCurrentScreenOptions;
import app.capgo.capacitor.firebase.analytics.classes.options.SetEnabledOptions;
import app.capgo.capacitor.firebase.analytics.classes.options.SetSessionTimeoutDurationOptions;
import app.capgo.capacitor.firebase.analytics.classes.options.SetUserIdOptions;
import app.capgo.capacitor.firebase.analytics.classes.options.SetUserPropertyOptions;
import app.capgo.capacitor.firebase.analytics.classes.results.GetAppInstanceIdResult;
import app.capgo.capacitor.firebase.analytics.interfaces.EmptyResultCallback;
import app.capgo.capacitor.firebase.analytics.interfaces.NonEmptyResultCallback;
import app.capgo.capacitor.firebase.analytics.interfaces.Result;
import com.getcapacitor.JSObject;
import com.getcapacitor.JSObject;
import com.getcapacitor.Logger;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "FirebaseAnalytics")
public class FirebaseAnalyticsPlugin extends Plugin {

    private final String pluginVersion = "8.6.2";

    public static final String TAG = "FirebaseAnalytics";

    private FirebaseAnalytics implementation;

    @PluginMethod
    public void getAppInstanceId(PluginCall call) {
        try {
            NonEmptyResultCallback<GetAppInstanceIdResult> callback = new NonEmptyResultCallback<>() {
                @Override
                public void success(@NonNull GetAppInstanceIdResult result) {
                    resolveCall(call, result);
                }

                @Override
                public void error(@NonNull Exception exception) {
                    rejectCall(call, exception);
                }
            };

            implementation.getAppInstanceId(callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    @PluginMethod
    public void initiateOnDeviceConversionMeasurementWithEmailAddress(PluginCall call) {
        rejectCallAsUnimplemented(call);
    }

    @PluginMethod
    public void initiateOnDeviceConversionMeasurementWithHashedEmailAddress(PluginCall call) {
        rejectCallAsUnimplemented(call);
    }

    @PluginMethod
    public void initiateOnDeviceConversionMeasurementWithHashedPhoneNumber(PluginCall call) {
        rejectCallAsUnimplemented(call);
    }

    @PluginMethod
    public void initiateOnDeviceConversionMeasurementWithPhoneNumber(PluginCall call) {
        rejectCallAsUnimplemented(call);
    }

    @PluginMethod
    public void isEnabled(PluginCall call) {
        rejectCallAsUnimplemented(call);
    }

    public void load() {
        implementation = new FirebaseAnalytics(this.getContext(), this.getBridge());
    }

    @PluginMethod
    public void logEvent(PluginCall call) {
        try {
            LogEventOptions options = new LogEventOptions(call);
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

            implementation.logEvent(options, callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    @PluginMethod
    public void logTransaction(PluginCall call) {
        rejectCallAsUnimplemented(call);
    }

    @PluginMethod
    public void resetAnalyticsData(PluginCall call) {
        try {
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

            implementation.resetAnalyticsData(callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    @PluginMethod
    public void setConsent(PluginCall call) {
        try {
            SetConsentOptions options = new SetConsentOptions(call);
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

            implementation.setConsent(options, callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    @PluginMethod
    public void setCurrentScreen(PluginCall call) {
        try {
            SetCurrentScreenOptions options = new SetCurrentScreenOptions(call);
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

            implementation.setCurrentScreen(options, callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    @PluginMethod
    public void setEnabled(PluginCall call) {
        try {
            SetEnabledOptions options = new SetEnabledOptions(call);
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

            implementation.setEnabled(options, callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    @PluginMethod
    public void setSessionTimeoutDuration(PluginCall call) {
        try {
            SetSessionTimeoutDurationOptions options = new SetSessionTimeoutDurationOptions(call);
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

            implementation.setSessionTimeoutDuration(options, callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    @PluginMethod
    public void setUserId(PluginCall call) {
        try {
            SetUserIdOptions options = new SetUserIdOptions(call);
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

            implementation.setUserId(options, callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    @PluginMethod
    public void setUserProperty(PluginCall call) {
        try {
            SetUserPropertyOptions options = new SetUserPropertyOptions(call);
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

            implementation.setUserProperty(options, callback);
        } catch (Exception exception) {
            rejectCall(call, exception);
        }
    }

    private void rejectCall(@NonNull PluginCall call, @NonNull Exception exception) {
        String message = exception.getMessage();
        Logger.error(TAG, message, exception);
        String code = exception instanceof CustomException ? ((CustomException) exception).getCode() : null;
        if (code == null) {
            call.reject(message);
        } else {
            call.reject(message, code);
        }
    }

    private void rejectCallAsUnimplemented(@NonNull PluginCall call) {
        call.unimplemented("Not implemented on Android.");
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
    public void getSessionId(PluginCall call) {
        try {
            implementation.getSessionId(
                new GetSessionIdCallback() {
                    @Override
                    public void success(@Nullable Long sessionId) {
                        JSObject result = new JSObject();
                        if (sessionId != null) {
                            result.put("sessionId", sessionId);
                        }
                        call.resolve(result);
                    }

                    @Override
                    public void error(String message) {
                        call.reject(message);
                    }
                }
            );
        } catch (Exception exception) {
            Logger.error(TAG, exception.getMessage(), exception);
            String message = exception.getMessage() != null ? exception.getMessage() : "Get session id failed.";
            call.reject(message);
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
