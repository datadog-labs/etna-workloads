Scalar subquery with DISTINCT, ORDER BY and LIMIT/OFFSET where OFFSET exceeds the row count.
The fix NULLs the destination register before the sorter loop; the buggy shell skips that,
so the register keeps a stale value from the previous outer row.
Expected (clean): three NULL rows. Buggy: see ./check.sh output.
