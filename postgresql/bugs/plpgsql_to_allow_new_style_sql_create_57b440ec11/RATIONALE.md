# Rationale

## src/pl/plpgsql/src/pl_gram.y, make_execsql_stmt()
Traces to the fix_impl.patch hunk that changes the end-of-statement test from
`if (tok == ';')` to `if (tok == ';' && paren_depth == 0 && begin_depth == 0)`.
I put the original `if (tok == ';')` back. The paren and BEGIN/END tracking code is still
there but no longer affects statement termination. A semicolon inside the
BEGIN ATOMIC ... END body of a new-style SQL `CREATE FUNCTION` therefore ends the
statement early, which is the bug.

## Failing oracle cases
- src/pl/plpgsql/src||plpgsql_misc
