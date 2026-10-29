# Rationale

Changed `src/fkey.c`, `fkActionTrigger()`: the trigger step's `pSrc` item (the child table
of the ON UPDATE/DELETE CASCADE / SET NULL / SET DEFAULT action) no longer gets
`u4.pSchema = pTab->pSchema` and `fg.fixedSchema = 1`. It is back to just
`zName = sqlite3DbStrNDup(db, zFrom, nFrom)`.

This reverses the fix's second hunk (`pStep->pSrc` block). Without a fixed schema the
temp trigger resolves the child table name by searching all databases, so a
same-named table in another schema (main.c1 vs aux.c1) can be picked.

The first hunk (RESTRICT `pSrc`) was left as is. In 3.54.1 it is the fixed-schema form,
and the cascade case in the oracle doesn't use it.

## Oracle failures
fkey8-7.2 (UPDATE aux.p1 raises "FOREIGN KEY constraint failed" instead of succeeding),
fkey8-7.3 and fkey8-7.4 (the update is rolled back, so the values stay 10/20 and the child rows are not cascaded).
