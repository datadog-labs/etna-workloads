# Rationale

Fix hunk (src/select.c, multiSelect): the merge KeyInfo's sort-order array was
placed at a wrong offset (`aCopy = (CollSeq**)&pKeyInfo[1]` instead of
`&pKeyInfo->aColl[nCol]`), so the sort-order bytes overlapped the collation array.

In 3.54.1 that layout is built in `multiSelectByMergeKeyInfo()` (the ORDER BY
KeyInfo for compound-select merging). `sqlite3KeyInfoAlloc()` correctly sets
`aSortFlags = &aColl[N+X]`; I re-introduced the overlap by resetting, right after
allocation, `pRet->aSortFlags = (u8*)&pRet->aColl[0];`. The sort flags then alias the
collation pointers, as in the old code where the sort order array overlapped aColl.

Oracle: test/insert3.test fails (14 of 18 cases): insert3-1.4.1 / 1.4.2
(compound SELECT ... UNION ALL ... ORDER BY) hit an assertion in sqlite3ValueText
(corrupt collation/encoding) and the rest of the file aborts. bind.test is unaffected.
