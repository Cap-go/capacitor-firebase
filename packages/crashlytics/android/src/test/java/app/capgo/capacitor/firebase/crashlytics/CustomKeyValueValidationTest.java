package app.capgo.capacitor.firebase.crashlytics;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class CustomKeyValueValidationTest {

    @Test
    public void rejectsMissingValueForStringType() {
        assertFalse(CustomKeyValueValidation.hasCustomKeyValue((Object) null, "string"));
    }

    @Test
    public void acceptsStringValueForStringType() {
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue("hello", "string"));
    }

    @Test
    public void rejectsIncompatibleValueForStringType() {
        assertFalse(CustomKeyValueValidation.hasCustomKeyValue(42, "string"));
    }

    @Test
    public void acceptsIntegerValueForIntType() {
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(7, "int"));
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(7, "long"));
    }

    @Test
    public void rejectsStringValueForIntType() {
        assertFalse(CustomKeyValueValidation.hasCustomKeyValue("7", "int"));
    }

    @Test
    public void acceptsBooleanValueForBooleanType() {
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(true, "boolean"));
    }

    @Test
    public void acceptsFloatValueForFloatType() {
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(1.5f, "float"));
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(1.5d, "float"));
    }

    @Test
    public void acceptsDoubleValueForDoubleType() {
        assertTrue(CustomKeyValueValidation.hasCustomKeyValue(2.5d, "double"));
    }
}
