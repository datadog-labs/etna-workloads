# Rationale

Fix hunk (src/where.c, whereLoopAddBtree): changed `whereUsablePartialIndex(pNew->iTab, ...)` to `pSrc->iCursor`.
In 3.54.1 the call is at the "Loop over all indices" loop in whereLoopAddBtree (signature now also takes jointype).
Reverted by passing `pNew->iTab` (the FROM-clause index) again instead of `pSrc->iCursor` (the cursor number).
The two differ when a subquery/view is flattened or cursors are otherwise not numbered by FROM position, so the partial index
implication check is done against the wrong table.

Oracle failures: index7-6.2 (wrong result: empty instead of `1 xyz abc {not xyz}`, partial index wrongly used)
and index7-6.4 (plan is SCAN t4 instead of SEARCH using i4).
