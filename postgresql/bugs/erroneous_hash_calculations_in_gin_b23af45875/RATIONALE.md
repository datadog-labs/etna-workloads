# Rationale

File: src/backend/utils/adt/jsonb_gin.c, function gin_extract_jsonb_path(). All hunks trace to fix_impl.patch (single file).

- WJB_BEGIN_ARRAY/OBJECT: restored the `if (parent->parent)` / else branch, which seeds the outermost hash with JB_FARRAY/JB_FOBJECT (fix removed this).
- WJB_KEY: restored `stack->hash = stack->parent->hash` before mixing in the key (fix instead relied on a reset after each value).
- WJB_ELEM: restored the separate reset to the parent hash with FALL THRU into WJB_VALUE.
- Removed the "reset hash for next key, value, or sub-object" steps after WJB_VALUE/ELEM and after WJB_END_ARRAY/OBJECT, which the fix added.

Together these bring back the old, erroneous hash calculation for path GIN entries, so the resulting hashes (and index entries) differ from the correct ones; the fix's expected results no longer match.

Failing oracle case: src/test/regress||jsonb
