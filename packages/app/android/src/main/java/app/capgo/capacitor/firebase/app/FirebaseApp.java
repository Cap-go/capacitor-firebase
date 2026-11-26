package app.capgo.capacitor.firebase.app;

import androidx.annotation.NonNull;
import app.capgo.capacitor.firebase.app.classes.CustomExceptions;
import app.capgo.capacitor.firebase.app.classes.options.InitializeAppOptions;
import app.capgo.capacitor.firebase.app.classes.results.GetAppsResult;
import app.capgo.capacitor.firebase.app.interfaces.EmptyResultCallback;
import app.capgo.capacitor.firebase.app.interfaces.NonEmptyResultCallback;
import java.util.List;

public class FirebaseApp {

    @NonNull
    private final FirebaseAppPlugin plugin;

    public FirebaseApp(@NonNull FirebaseAppPlugin plugin) {
        this.plugin = plugin;
    }

    public void getApps(@NonNull NonEmptyResultCallback<GetAppsResult> callback) {
        List<com.google.firebase.FirebaseApp> apps = com.google.firebase.FirebaseApp.getApps(plugin.getContext());
        callback.success(new GetAppsResult(apps));
    }

    public void initializeApp(@NonNull InitializeAppOptions options, @NonNull EmptyResultCallback callback) {
        String name = options.getName();
        if (isAppInitialized(name)) {
            callback.error(CustomExceptions.APP_ALREADY_EXISTS);
            return;
        }
        com.google.firebase.FirebaseApp.initializeApp(plugin.getContext(), options.getOptions(), name);
        callback.success();
    }

    private boolean isAppInitialized(@NonNull String name) {
        for (com.google.firebase.FirebaseApp app : com.google.firebase.FirebaseApp.getApps(plugin.getContext())) {
            if (app.getName().equals(name)) {
                return true;
            }
        }
        return false;
    }
}
