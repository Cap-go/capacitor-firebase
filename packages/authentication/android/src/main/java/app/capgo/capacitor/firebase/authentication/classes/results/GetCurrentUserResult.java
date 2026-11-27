package app.capgo.capacitor.firebase.authentication.classes.results;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.authentication.FirebaseAuthenticationHelper;
import app.capgo.capacitor.firebase.authentication.interfaces.Result;
import com.getcapacitor.JSObject;
import com.google.firebase.auth.FirebaseUser;
import org.json.JSONObject;

public class GetCurrentUserResult implements Result {

    @Nullable
    private final FirebaseUser user;

    public GetCurrentUserResult(@Nullable FirebaseUser user) {
        this.user = user;
    }

    @Override
    @NonNull
    public JSObject toJSObject() {
        JSObject userResult = FirebaseAuthenticationHelper.createUserResult(user);
        JSObject result = new JSObject();
        result.put("user", (userResult == null ? JSONObject.NULL : userResult));
        return result;
    }
}
