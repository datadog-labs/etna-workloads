# Rationale

Fix hunk 1 (src/where.c, whereLoopAddBtree loop header): the fix moved the
"only consider the INDEXED BY index" logic into the for-loop increment
(`pProbe = isIndexedBy ? 0 : pProbe->pNext`). I restored the old increment
`pProbe=pProbe->pNext`.

Fix hunk 2 (end of loop body): the fix removed the trailing
`if( pSrc->pIBIndex ) break;`. I restored it (using today's
`pSrc->fg.isIndexedBy`). That break is skipped by the `continue` taken when a
partial index is unusable, so the loop proceeds to the table's other indexes
and INDEXED BY is not honoured (no "no query solution" error).

Failing oracle case: indexedby-12.2 (`SELECT * FROM o1 INDEXED BY p2 ORDER BY 1`
should give "no query solution"; the planner instead picks another index).
