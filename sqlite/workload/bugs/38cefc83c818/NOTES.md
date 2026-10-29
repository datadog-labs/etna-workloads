repro.sql: partial index `i0 ON t0(1) WHERE c0 NOT NULL` plus a row with c0 NULL, then
`SELECT 1 FROM t0 WHERE (t0.c0 IS FALSE) IS FALSE`.
Clean returns one row (1). Buggy wrongly concludes the WHERE implies c0 IS NOT NULL
(exprImpliesNotNull passes seenNot instead of 1 for TK_TRUTH), uses the partial index,
and returns no rows.
