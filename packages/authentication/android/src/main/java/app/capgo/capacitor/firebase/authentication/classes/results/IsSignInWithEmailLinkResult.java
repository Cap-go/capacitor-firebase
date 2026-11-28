package app.capgo.capacitor.firebase.authentication.classes.results;

import androidx.annotation.NonNull;
import app.capgo.capacitor.firebase.authentication.interfaces.Result;
import com.getcapacitor.JSObject;

public class IsSignInWithEmailLinkResult implements Result {

    private final boolean isSignInWithEmailLink;

    public IsSignInWithEmailLinkResult(boolean isSignInWithEmailLink) {
        this.isSignInWithEmailLink = isSignInWithEmailLink;
    }

    @Override
    @NonNull
    public JSObject toJSObject() {
        JSObject result = new JSObject();
        result.put("isSignInWithEmailLink", isSignInWithEmailLink);
        return result;
    }
}
