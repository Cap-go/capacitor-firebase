package app.capgo.capacitor.firebase.firestore.classes.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.firestore.FirebaseFirestoreHelper;
import app.capgo.capacitor.firebase.firestore.classes.constraints.QueryCompositeFilterConstraint;
import app.capgo.capacitor.firebase.firestore.interfaces.QueryNonFilterConstraint;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import org.json.JSONException;

public class GetCountFromServerOptions {

    @NonNull
    private final String reference;

    @Nullable
    private final QueryCompositeFilterConstraint compositeFilter;

    @NonNull
    private final QueryNonFilterConstraint[] queryConstraints;

    public GetCountFromServerOptions(
        @NonNull String reference,
        @Nullable JSObject compositeFilter,
        @Nullable JSArray queryConstraints,
        @NonNull com.google.firebase.firestore.FirebaseFirestore firestore
    ) throws JSONException {
        this.reference = reference;
        this.compositeFilter = FirebaseFirestoreHelper.createQueryCompositeFilterConstraintFromJSObject(compositeFilter, firestore);
        this.queryConstraints = FirebaseFirestoreHelper.createQueryNonFilterConstraintArrayFromJSArray(queryConstraints);
    }

    @NonNull
    public String getReference() {
        return reference;
    }

    @Nullable
    public QueryCompositeFilterConstraint getCompositeFilter() {
        return compositeFilter;
    }

    @NonNull
    public QueryNonFilterConstraint[] getQueryConstraints() {
        return queryConstraints;
    }
}
