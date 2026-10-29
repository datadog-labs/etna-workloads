Query `t1 LEFT JOIN t2 WHERE t2.y IS NOT 'abc'` over an empty t2.
The buggy shell omits TK_ISNOT from impliesNotNullRow(), so the LEFT JOIN is wrongly
reduced to an inner join and returns no rows. The clean shell returns both t1 rows
with NULLs for t2 (`1|2|||x` and `3|4|||x`).
