# Rationale

File: src/backend/utils/adt/jsonfuncs.c

- `jsonb_delete()` and `jsonb_delete_path()`: removed the `JB_ROOT_IS_SCALAR(in)` check that raised
  "cannot delete from scalar" / "cannot delete path in scalar". This traces to the fix.patch hunks in
  jsonb_delete and jsonb_delete_path that added those checks. Without them, scalar inputs
  (e.g. `'"a"'::jsonb - 'a'`) go through the array/object iteration code instead of erroring,
  so the bug returns: wrong result or an assertion failure instead of the error.

Failing oracle case: src/test/regress||jsonb
