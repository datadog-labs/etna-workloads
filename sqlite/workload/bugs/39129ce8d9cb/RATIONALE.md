# Rationale

Fix: where.c must let the planner use the PK columns appended to every index
entry on a WITHOUT ROWID table (hunk in `whereLoopAddBtreeIndex`: recursion
bound changed from `nKeyCol + (zName!=0)` to `nColumn`).

Change (src/where.c, end of the loop in `whereLoopAddBtreeIndex`): the recursive
call condition `nEq<nColumn && (nEq<nKeyCol || idxType!=PRIMARYKEY)` is replaced
with `nEq<nKeyCol + HasRowid(pTable)`. This is the pre-fix bound, i.e. only key
columns (plus the rowid on rowid tables) are extended; the trailing PK columns
of a WITHOUT ROWID index are never added as further equality/range terms.
For rowid tables nColumn==nKeyCol+1, so behaviour is unchanged there.

Oracle failures (test/without_rowid1.test): 5.1 and 5.7.{1..5}.2 — the EXPLAIN
QUERY PLAN no longer shows `i45 (b=? AND a>?)` / `i46 (c=? AND a=?)` etc.
Query results stay correct.
