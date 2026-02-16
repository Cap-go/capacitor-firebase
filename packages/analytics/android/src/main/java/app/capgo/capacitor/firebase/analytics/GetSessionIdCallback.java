package app.capgo.capacitor.firebase.analytics;

import androidx.annotation.Nullable;

public interface GetSessionIdCallback {
    void success(@Nullable Long sessionId);
    void error(String message);
}
