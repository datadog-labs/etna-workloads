# Rationale

## Change: tree/src/resolve.c, resolveExprStep (TK_FUNCTION, aggregate branch)
Reverses the single implementation hunk of the fix:
- `assert( pDef!=0 || IN_RENAME_OBJECT );` -> `assert( pDef!=0 );`
- `if( pNC2 && pDef ){` -> `if( pNC2 ){`

During ALTER TABLE RENAME, the schema is re-resolved with IN_RENAME_OBJECT and a FILTER
clause on an unregistered function (`a () FILTER (...)`) leaves pDef==0. Without the guard,
the code asserts (debug builds) or dereferences NULL pDef->funcFlags (release builds).
3.54.1's code is otherwise unchanged around it (extra op2/ORDER flags lines), so the revert is equivalent.

## Oracle failure
altertab3-17.2 (the test added by the fix) aborts: `Assertion 'pDef!=0' failed` in resolveExprStep.
