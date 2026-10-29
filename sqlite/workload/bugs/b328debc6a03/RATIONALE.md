# Rationale

Changed `tree/src/fkey.c`, `fkLookupParent()`, the self-referencing INSERT
branch (`pTab==pFKey->pFrom && nIncr==1`, multi-column/index path).

Removed `sqlite3VdbeChangeP5(v, SQLITE_JUMPIFNULL)` after the `OP_Ne`
comparing child-key and parent-key registers. This reverses the fix's added
`sqlite3VdbeChangeP5(v, SQLITE_JUMPIFNULL)` hunk. Without it, a NULL
parent-key value in the row being inserted makes OP_Ne fall through instead
of jumping, so the row is wrongly treated as matching itself and the
constraint counter is not incremented, so a violating row is accepted.

The fix's other hunk (IPK handling, `iParent = regData`) is already
equivalent in the pre-fix form for the rowid case, so it was left alone.

Oracle failures: fkey3-3.1.2 and fkey3-3.2.2. The inserts with a NULL
parent-key value succeed instead of failing with "foreign key constraint failed".
