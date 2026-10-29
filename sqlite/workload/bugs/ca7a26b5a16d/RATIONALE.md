# Rationale

Fix hunk reversed: in `whereUsablePartialIndex()` (src/where.c) the added condition
`(isLeft==0 || ExprHasProperty(pExpr, EP_FromJoin))` — in 3.54.1 spelled
`((jointype & JT_OUTER)==0 || ExprHasProperty(pExpr, EP_OuterON))` — is removed.
The isLeft parameter became `jointype` and is still passed by the caller in
whereLoopAddBtree, so the caller/signature hunks need no change (the parameter is still
used for the JT_LTORJ check). Without the condition, a plain WHERE term can again qualify a
partial index on the right table of a LEFT JOIN.

Oracle failure: join-21.10 fails. With `CREATE INDEX i0 ON t0(aa) WHERE aa ISNULL`,
queries 21/22 (`LEFT JOIN t0 WHERE aa ISNULL`) wrongly use the partial index, returning
extra/incorrect rows versus the expected `{13 1 {} 14 1 {} 23 1 {} 24 1 {}}`.
