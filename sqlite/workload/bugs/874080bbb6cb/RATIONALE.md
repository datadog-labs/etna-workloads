# Rationale

## Change
`tree/src/btree.c`, `sqlite3BtreeInsert()`, branch `else if( loc<0 && pPage->nCell>0 )`:
removed `pCur->curFlags &= ~(BTCF_ValidNKey|BTCF_ValidOvfl);` after `idx = ++pCur->ix;`.

Reverses the fix's only implementation hunk (which added
`pCur->curFlags &= ~BTCF_ValidNKey;` on that line). In 3.54.1 the line also clears
BTCF_ValidOvfl; removing it restores the pre-fix state: the cursor moves to the next
slot (ix++) but keeps BTCF_ValidNKey, so cached info.nKey is stale.

## Oracle failures
conflict3-12.2 (`REPLACE INTO t2 VALUES(NULL,'112'),(111,'111B')`) crashes with
`Assertion 'CORRUPT_DB || pC->movetoTarget==iKey' failed` in sqlite3VdbeExec; the stale
nKey makes the following insert/seek think the cursor is already on the target key.
12.3 and later cases do not run.
