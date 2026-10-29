# Rationale

Fix hunk 1 (src/where.c, codeOneLoopStart): added `else{ pLevel->op = OP_Noop; }`
so the multi-index OR loop has a valid end-of-loop opcode when no RowSet is used
(UPDATE/DELETE, i.e. WHERE_DUPLICATES_OK). Before the fix `pLevel->op` was left unset in that case.

In 3.54.1 the code is in src/wherecode.c (Case 5, "MULTI-INDEX OR"). It sets
`pLevel->op = OP_Return` unconditionally. I made that assignment conditional on
`(wctrlFlags & WHERE_DUPLICATES_OK)==0`, so UPDATE/DELETE OR-loops again leave `op` unset.

Fix hunk 2 (the INDEXED BY "cannot use index" check in sqlite3WhereBegin) has no counterpart
in 3.54.1: that code was removed and redesigned. I did not change anything for it.

Oracle result: where9-6.2.2 (DELETE ... WHERE b IS NULL OR c IS NULL OR d IS NULL) fails
with `Assertion pLevel->op==OP_Return failed` in sqlite3WhereCodeOneLoopStart.
Later where9-6.x tests don't run after that. Without assertions the unset op would
produce a bad opcode at loop end.
