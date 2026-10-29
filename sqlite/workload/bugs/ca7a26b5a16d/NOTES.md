Partial index `i0 ON t0(aa) WHERE aa ISNULL` on the right table of a LEFT JOIN.
With the bug, a WHERE-clause term `aa ISNULL` wrongly qualifies the partial index,
so `SELECT 21 ... LEFT JOIN t0 WHERE aa ISNULL` returns a row (`21|1|`) instead of
no rows (t0 has aa=1, so the WHERE filter should reject the null-extended row).
The clean shell outputs only the ON-clause row `23|1|`.
