repro.sql: a scalar subquery with both DISTINCT and OFFSET, where OFFSET skips every row.
Clean shell: the subquery yields NULL (empty line; the comparison is NULL).
Buggy shell: the result register keeps the last row visited, so it prints `string` and `1`.
