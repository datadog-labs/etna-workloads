# Rationale

## src/backend/utils/adt/jsonpath_exec.c, executeItemOptUnwrapTarget (jpiDecimal case)
Traces to the jsonpath_exec.c hunk in fix.patch that replaces the numerictypmodin() call
with make_numeric_typmod_safe(..., jspThrowErrors(cxt) ? NULL : &escontext).
The current code keeps the safe helper, but the soft-error context is no longer passed (NULL),
so an out-of-range precision/scale in .decimal(p,s) always raises a hard error, even in silent
mode (e.g. the `jsonb_path_query(..., silent => true)` / `@?` cases), as before the fix.
The numeric.c/numeric.h hunks are only refactoring that supports this and are left in place.

## Failing oracle cases
- src/test/regress||jsonb_jsonpath
