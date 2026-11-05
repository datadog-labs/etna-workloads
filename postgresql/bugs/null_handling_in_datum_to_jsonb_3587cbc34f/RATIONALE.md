# Rationale
- File: src/backend/utils/adt/jsonb.c, function datum_to_jsonb_internal (was datum_to_jsonb).
- Traces to the fix_impl.patch hunk replacing the "work done recursively" test. The fix added `!is_null &&`. I removed it, so the old condition is back.
- Why this brings the bug back: with a NULL input, tcategory can still be in the JSON..CAST range (for example a NULL json/jsonb/cast-typed value). The function then returns early without pushing the jbvNull value, so the NULL is dropped.

Failing oracle case (expected): src/test/regress||jsonb
