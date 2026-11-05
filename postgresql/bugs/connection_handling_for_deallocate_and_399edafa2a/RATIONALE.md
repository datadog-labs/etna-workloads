# Rationale

Changed hunk: src/interfaces/ecpg/preproc/ecpg.trailer, rule `DeallocateStmt`.
Traces to the fix.patch ecpg.trailer hunk `DeallocateStmt: DEALLOCATE prepared_name { check_declared_list($2); ... }`.
I removed the `check_declared_list(@2)` and `check_declared_list(@3)` calls from the two
`DEALLOCATE [PREPARE] prepared_name` alternatives. As a result, DEALLOCATE no longer picks up the
connection from a prior `EXEC SQL AT conn DECLARE stmt STATEMENT`, so it uses the wrong
(default) connection.

Failing oracle case: src/interfaces/ecpg||sql/declare
