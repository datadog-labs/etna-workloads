# Rationale

Fix: in selectInnerLoop(), when `pSort->pDeferredRowLoad` is set, also set `regOrig = 0`
so pushOntoSorter() does not evaluate ORDER BY terms by copying (ECEL_REF) from result
registers that have not been loaded yet.

## Changes (tree/src/select.c, selectInnerLoop)
1. Removed `regOrig = 0;` after `pSort->pDeferredRowLoad = &sRowLoadInfo;`
   — reverses the fix's one-line implementation hunk directly (the comment hunk is documentation only).
2. Removed `regOrig = 0;` in the "adjust nResultCol" loop. In 3.54.1 this second path
   also zeroes regOrig whenever any result column is omitted from the sorter (iOrderByCol>0),
   which independently masks the same defect (the oracle query hits it), so reverting (1)
   alone changed nothing. It is the same defect: regOrig must be 0 when result registers
   may not be populated at ORDER BY evaluation time.

## Oracle failure
orderby1.test fails with `Assertion 'memIsValid(pRec)' failed` in sqlite3VdbeExec
(first hit at orderby1-4.0, aborting the run before 10.0): ORDER BY terms are copied from
result registers that have not been loaded due to the deferred row load.
