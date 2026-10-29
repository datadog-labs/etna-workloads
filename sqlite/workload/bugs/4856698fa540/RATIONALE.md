# Rationale

Fix hunk reversed: src/analyze.c, in analyzeOneTable, the fix replaced an `OP_Ne`
without a collating sequence (with a TODO) by `OP_Ne` carrying
`sqlite3LocateCollSeq(pParse, pIdx->azColl[i])` as a P4_COLLSEQ.

In 3.54.1 the same logic is in the per-column distinctness loop (`for(i=0; i<nColTest; i++)`).
I removed the `pColl` lookup and changed the `sqlite3VdbeAddOp4(... OP_Ne ..., pColl, P4_COLLSEQ)`
back to `sqlite3VdbeAddOp3(v, OP_Ne, regTemp, 0, regPrev+i)`, so comparisons use
the default binary collation regardless of the index's collation.

Failing oracle case: analyze4-2.0. Expected `t2a {8 4} t2b {8 2} t2c {8 1} t2c2 {8 4} t2c3 {8 2}`,
got `{8 1}` for every index (nocase/rtrim indexes counted as binary-distinct rows).
