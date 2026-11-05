# Rationale

Hunk: src/backend/executor/execGrouping.c, BuildTupleHashTable().
Traces to the fix_impl.patch hunk in BuildTupleHashTableExt().

The fix changed the comparator's input-slot ops from `&TTSOpsMinimalTuple` to `NULL`, meaning the slot type is unknown. In current code the equivalent is the caller-supplied `inputOps`. I changed that argument back to `&TTSOpsMinimalTuple`.

This makes ExecBuildGroupingEqual assume the input slot is always a minimal tuple. WITH RECURSIVE UNION can pass non-minimal slots, so this fails an assertion or misreads the slot.

Failing oracle case: src/test/regress||with
