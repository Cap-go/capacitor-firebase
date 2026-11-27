package app.capgo.capacitor.firebase.authentication.classes.options;

import androidx.annotation.NonNull;
import app.capgo.capacitor.firebase.authentication.classes.CustomExceptions;
import com.getcapacitor.PluginCall;

public class IsSignInWithEmailLinkOptions {

    @NonNull
    private final String emailLink;

    public IsSignInWithEmailLinkOptions(@NonNull PluginCall call) throws Exception {
        this.emailLink = IsSignInWithEmailLinkOptions.getEmailLinkFromCall(call);
    }

    @NonNull
    public String getEmailLink() {
        return emailLink;
    }

    @NonNull
    private static String getEmailLinkFromCall(@NonNull PluginCall call) throws Exception {
        String emailLink = call.getString("emailLink");
        if (emailLink == null) {
            throw CustomExceptions.EMAIL_LINK_MISSING;
        }
        return emailLink;
    }
}
