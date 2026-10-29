# Rationale

In 3.54.1 the fix's own hunks are already not needed: `where.c` has the pre-fix
condition `nEq<nKeyCol || idxType!=PRIMARYKEY` (no `bIdxRowid`), so the bug is
instead masked by later code in `whereLoopAddBtreeIndex()` (tag-20250707-01):
the `bRedundant` check, which drops an index column whose IN-term matches the
same vector-IN field (`u.x.iField`) as an earlier column of the same WhereLoop.
For `UNIQUE(Item, Id)` with `Id` the rowid alias, the index's trailing rowid
column is the same field as `Id`, which is exactly the fix's scenario.

Change (src/where.c, `whereLoopAddBtreeIndex`): removed the `bRedundant`
variable, the `iField` comparison and the `if( bRedundant ){ nLTerm--; continue; }`
block. This restores the pre-fix behaviour: the extra rowid column is added
again as a further equality term of the same IN operator, which the fix
(`bIdxRowid`) was meant to prevent. It is the same defect fixed a second time.

Oracle: the rowvalue-34.1 scenario (and rowvalue-21.0) now hit
`Assertion 'removeUnindexableInClauseTerms: 0'` in a debug build, aborting the
test run, so the oracle cases from 21.0 on (including 34.x) fail.
