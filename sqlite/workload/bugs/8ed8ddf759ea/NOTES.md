Reproducer: a UNIQUE index on the expression abs(b) over rows with NULL b, followed by `GROUP BY a, abs(b)`.
The buggy shell treats the expression index as non-NULL and distinct, so it skips the sort/grouping step.
Clean shell returns 2 groups (`NULL NULL |` and `1 NULL |`). Buggy shell returns 3 rows (`1 NULL |`, `NULL NULL |`, `1 NULL |`), failing to merge the two a=1 rows.
