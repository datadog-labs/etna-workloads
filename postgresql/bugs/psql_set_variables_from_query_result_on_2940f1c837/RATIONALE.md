# Rationale
File: src/bin/psql/common.c, function ExecQueryAndProcessResults (the single hunk in fix.patch / fix_impl.patch).
Fix: set variables from the last result even on failure (`SetResultVariables(result, success)`).
Bug restored: the call is guarded by `&& success` and passes `true`, so when printing tuples fails, the variables (SQLSTATE, ERROR, ROW_COUNT etc.) are not set from the result.
Failing oracle case: src/test/regress||psql
