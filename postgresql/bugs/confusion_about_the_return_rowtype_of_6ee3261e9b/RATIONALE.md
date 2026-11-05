# Rationale

Hunk: `src/src/backend/executor/functions.c`, `check_sql_fn_retval()`.
Traces to the fix.patch hunk in functions.c that changed `if (tlistlen == 1)` to
`if (tlistlen == 1 && prokind != PROKIND_PROCEDURE)`.

I reverted that condition. A procedure with a single composite output parameter
(rettype RECORD) again takes the "single composite column" shortcut. The CALL code
then gets the composite's fields instead of one column per output parameter.

The `prokind` parameter and its callers are left in place. Only the check that uses it is removed.

Failing oracle case: `src/test/regress||create_procedure`
