# Rationale

File: src/backend/utils/adt/format_type.c, function format_type().
Traces to the fix_impl.patch hunk at `format_type(PG_FUNCTION_ARGS)`. The fix set FORMAT_TYPE_TYPEMOD_GIVEN only when the typemod argument is non-NULL. The change reverts that, so the flag is always set and a NULL typemod is treated as an explicit typemod of -1.

Effect: format_type(oid, NULL) now gives the typemod = -1 output instead of the no-typemod output. That is the old, broken behavior.

Oracle case expected to fail: src/test/regress||create_type
