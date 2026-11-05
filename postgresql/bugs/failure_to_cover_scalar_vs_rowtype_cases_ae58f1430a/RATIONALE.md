# Rationale
Hunk: src/pl/plpgsql/src/pl_exec.c, exec_stmt_return(), PLPGSQL_DTYPE_VAR/PROMISE case.
Traces to the fix.patch hunk adding the `retistuple && !retisnull` "cannot return non-composite value" check
for a simple-variable RETURN. Removing it again means a scalar variable returned from a composite-returning
function is no longer rejected (scalar-vs-rowtype case uncovered), so the error is lost / bad data is returned.

Failing oracle case: src/test/regress||plpgsql
