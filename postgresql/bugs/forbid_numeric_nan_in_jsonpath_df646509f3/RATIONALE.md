# Rationale
Reverts "Forbid numeric NaN in jsonpath".

1. src/backend/utils/adt/jsonb_util.c, convertJsonbScalar (case jbvNumeric): re-added the
   block that stores a numeric NaN as the string "NaN" (hunk 1 of fix_impl.patch, reversed).
   Jsonb can again silently turn NaN into a string.
2. src/backend/utils/adt/jsonpath_exec.c, executeItemOptUnwrapTarget (jpiDouble), numeric branch:
   removed the `isinf(val) || isnan(val)` rejection (hunk 2 reversed; the code now uses
   float8in_internal + ErrorSaveContext, so the check is a separate if-block that was deleted).
3. Same function, string branch: `isinf(val) || isnan(val)` reduced to `isinf(val)` (hunk 3 reversed),
   so .double() on the string "NaN" is accepted.

Failing oracle case: src/test/regress||jsonb_jsonpath
