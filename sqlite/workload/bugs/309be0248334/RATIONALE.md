# Rationale

Fix (ticket #2514) inverted the seek operator (OP_Last->OP_Rewind, OP_MoveGt->OP_MoveLt)
in simpleMinMaxQuery() when the index's first column is DESC. In 3.54.1 simpleMinMaxQuery
no longer exists; min/max is done by adding an ORDER BY and letting
wherePathSatisfiesOrderBy() (src/where.c) decide scan direction, with the index sort
order `revIdx = pIndex->aSortOrder[j] & KEYINFO_ORDER_DESC` XORed into `rev`.

Change: in wherePathSatisfiesOrderBy, when wctrlFlags has WHERE_ORDERBY_MIN/MAX,
force `revIdx = 0`, i.e. the index sort order is ignored for min/max queries, so a
DESC index is scanned in the wrong direction -- the same effect as the missing seek
inversion. Normal ORDER BY is untouched.

Failing oracle cases (8/64): minmax2-1.5, 1.7, 7.1-7.4, 10.3, 10.4. E.g. with
`CREATE INDEX t1i1 ON t1(x DESC)`, `SELECT min(x)`/`max(x)` return the wrong end of
the index (10.4 returns NULL instead of 2).
