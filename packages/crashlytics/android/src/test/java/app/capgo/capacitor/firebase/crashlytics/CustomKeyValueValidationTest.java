package app.capgo.capacitor.firebase.crashlytics;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import com.getcapacitor.JSObject;
import com.getcapacitor.PluginCall;
import org.junit.Test;

public class CustomKeyValueValidationTest {

    private PluginCall callWith(JSObject data) {
        return new PluginCall(null, "FirebaseCrashlytics", "1", "setCustomKey", data);
    }

    @Test
    public void rejectsMissingValueForStringType() {
        PluginCall call = callWith(new JSObject());
        assertFalse(CustomKeyValueValidation.hasCustomKeyValue(call, "string"));
    }

    @Test
    public void acceptsStringValueForStringType() {
        JSObject data = new JSObject();
        data.put("value", "hello");
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(callWith(data), "string"));
    }

    @Test
    public void rejectsIncompatibleValueForStringType() {
        JSObject data = new JSObject();
        data.put("value", 42);
        assertFalse(CustomKeyValueValidation.hasCustomKeyValue(callWith(data), "string"));
    }

    @Test
    public void acceptsIntegerValueForIntType() {
        JSObject data = new JSObject();
        data.put("value", 7);
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(callWith(data), "int"));
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(callWith(data), "long"));
    }

    @Test
    public void rejectsStringValueForIntType() {
        JSObject data = new JSObject();
        data.put("value", "7");
        assertFalse(CustomKeyValueValidation.hasCustomKeyValue(callWith(data), "int"));
    }

    @Test
    public void acceptsBooleanValueForBooleanType() {
        JSObject data = new JSObject();
        data.put("value", true);
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(callWith(data), "boolean"));
    }

    @Test
    public void acceptsFloatValueForFloatType() {
        JSObject data = new JSObject();
        data.put("value", 1.5f);
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(callWith(data), "float"));
    }

    @Test
    public void acceptsDoubleValueForDoubleType() {
        JSObject data = new JSObject();
        data.put("value", 2.5d);
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(callWith(data), "double"));
    }
}
