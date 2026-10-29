# Rationale

Fix hunk (src/fkey.c, sqlite3FkCheck): added a block, run when `isIgnoreErrors`
(DROP TABLE's implicit DELETE) and the parent table is missing (`pTo==0`),
that emits OP_IsNull checks plus `OP_FkCounter -1` so a child row whose parent
table is already dropped is treated as having an empty parent and the
deferred FK counter is decremented.

Change in tree/src/fkey.c: removed that whole block (the `if( pTo==0 ){...}`
in version-3.54.1, which uses sqlite3TableColumnToStorage instead of
`iFrom + regOld + 1`), leaving just `if( !isIgnoreErrors || db->mallocFailed ) return; continue;`
as before the fix. The assert from the fix is kept (it was part of the fix, harmless).

Effect: dropping a parent table with deferred FK rows, then the child, leaves the
FK counter non-zero, so COMMIT fails with "FOREIGN KEY constraint failed".

Oracle failures (8 of 12): 1.2, 1.4, 2.1-2.4, 3.2, 3.3. 1.2 fails at commit
with the FK error, and later cases cascade from the open transaction
("cannot start a transaction within a transaction"). 3.3 gets
`1 {FOREIGN KEY constraint failed}` instead of `0 {}`.
