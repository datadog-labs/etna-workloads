# Rationale

## src/pragma.c (PRAGMA foreign_key_check)
Fix hunk: added `if( regRow+j>pParse->nMem ) pParse->nMem = regRow+j;` after the
loop that loads child key columns into regRow..regRow+nCol.
In 3.54.1 the same guarantee is given by `sqlite3TouchRegister(pParse, regRow + pFK->nCol);`
just before that loop. I removed that call, so only `pTab->nCol+regRow` is
touched (before OpenTable). A foreign key with more columns than the table
(e.g. repeated column) then uses registers beyond nMem, as in the original bug.

## Oracle failures
fkey1-7.1 (`FOREIGN KEY(a,a,...x14) REFERENCES t0` on a 3-column table, then
PRAGMA foreign_key_check) aborts with assertion
`pOp->p3>0 && pOp->p3<=(p->nMem+1 - p->nCursor)` in sqlite3VdbeExec.
