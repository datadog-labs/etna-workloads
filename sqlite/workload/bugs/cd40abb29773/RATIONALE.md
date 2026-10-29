# Rationale (src/where.c, whereShortCut())

Fix 9f2eb3abac added an `nKeyCol > ArraySize(aLTermSpace)` skip and removed the
per-column `whereLoopResize(db, pLoop, j)` call. Both are reverted in 3.54.1:

1. Removed `|| pIdx->nKeyCol>ArraySize(pLoop->aLTermSpace)` (and the two asserts
   that depend on it) from the unique-index filter. Reverses the added
   condition/asserts hunk. whereShortCut() again considers unique indexes with
   more than 3 columns (aLTermSpace is 3 slots now, 4 then).
2. Re-added `whereLoopResize(pWInfo->pParse->db, pLoop, j);` before
   `pLoop->aLTerm[j] = pTerm;`. Reverses the removed call. Resizing to `j`
   slots (not j+1) leaves aLTerm[j] out of bounds, and the unchecked return
   value is a problem on OOM, which is the original defect.

Oracle: all 220 cases of test/tkt-9f2eb3abac.test fail; the run crashes/asserts
at case 1.1 (5-column PRIMARY KEY with equality on all columns).
