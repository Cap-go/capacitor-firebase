package app.capgo.capacitor.firebase.firestore.classes.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import app.capgo.capacitor.firebase.firestore.FirebaseFirestoreHelper;
import app.capgo.capacitor.firebase.firestore.classes.constraints.QueryCompositeFilterConstraint;
import app.capgo.capacitor.firebase.firestore.interfaces.QueryNonFilterConstraint;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import org.json.JSONException;

public class AddCollectionGroupSnapshotListenerOptions {

    @NonNull
    private String reference;

    @Nullable
    private QueryCompositeFilterConstraint compositeFilter;

    @NonNull
    private QueryNonFilterConstraint[] queryConstraints;

    private String callbackId;

    private boolean includeMetadataChanges;

    @Nullable
    private final String serverTimestampBehavior;

    public AddCollectionGroupSnapshotListenerOptions(
        String reference,
        @Nullable JSObject compositeFilter,
        @Nullable JSArray queryConstraints,
        @Nullable Boolean includeMetadataChanges,
        @Nullable String serverTimestampBehavior,
        String callbackId,
        @NonNull com.google.firebase.firestore.FirebaseFirestore firestore
    ) throws JSONException {
        this.reference = reference;
        this.compositeFilter = FirebaseFirestoreHelper.createQueryCompositeFilterConstraintFromJSObject(compositeFilter, firestore);
        this.queryConstraints = FirebaseFirestoreHelper.createQueryNonFilterConstraintArrayFromJSArray(queryConstraints);
        this.includeMetadataChanges = includeMetadataChanges == null ? false : includeMetadataChanges;
        this.serverTimestampBehavior = serverTimestampBehavior;
        this.callbackId = callbackId;
    }

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

    public boolean isIncludeMetadataChanges() {
        return includeMetadataChanges;
    }

    @Nullable
    public String getServerTimestampBehavior() {
        return serverTimestampBehavior;
    }

    public String getCallbackId() {
        return callbackId;
    }
}
