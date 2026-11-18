package app.capgo.capacitor.firebase.firestore.classes.options;

import androidx.annotation.NonNull;
import app.capgo.capacitor.firebase.firestore.FirebaseFirestoreHelper;
import com.getcapacitor.JSObject;
import java.util.Map;
import org.json.JSONException;

public class UpdateDocumentOptions {

    private String reference;
    private Map<String, Object> data;

    public UpdateDocumentOptions(String reference, JSObject data, @NonNull com.google.firebase.firestore.FirebaseFirestore firestore)
        throws JSONException {
        this.reference = reference;
        this.data = FirebaseFirestoreHelper.createHashMapFromJSONObject(data, firestore);
    }

    public String getReference() {
        return reference;
    }

    public Map<String, Object> getData() {
        return data;
    }
}
