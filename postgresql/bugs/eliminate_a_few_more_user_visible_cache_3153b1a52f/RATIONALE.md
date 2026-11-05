# Rationale
File: src/backend/utils/adt/ruleutils.c (fix.patch's only implementation file).

- pg_get_function_arguments, pg_get_function_identity_arguments, pg_get_function_result,
  pg_get_function_arg_default: when the PROCOID syscache lookup fails, these once again
  `elog(ERROR, "cache lookup failed for function %u")` instead of `PG_RETURN_NULL()`.
  This reverses all four fix.patch hunks. (The initStringInfo reordering in the first three
  hunks was not restored. It has no effect on behavior.)
  Calling these on a nonexistent function OID now raises a user-visible error instead of returning NULL.

Failing oracle case: src/test/regress||rules
