# Rationale

## src/fkey.c, exprTableRegister()
Reverses the single implementation hunk of the fix (fkScanChildren: `pCol = &pTab->aCol[iCol]; if( pTab->iPKey==iCol ) iCol = -1;`).
In 3.54.1 that logic moved into `exprTableRegister()`, which used `iCol>=0 && iCol!=pTab->iPKey` to
send the INTEGER PRIMARY KEY to the rowid register (`regBase`). The change drops the `iCol!=pTab->iPKey`
test, so the IPK is looked up as an ordinary column (`regBase+storage+1`), which does not hold the rowid. This is the
pre-fix behaviour: compound FK parent keys containing the IPK compare against the wrong register.

## Failing oracle cases
fkey2-ce7c13.1.1 and fkey2-ce7c13.1.4: `UPDATE tce71 SET b=200 WHERE a=100` spuriously fails with
"FOREIGN KEY constraint failed" instead of succeeding.
