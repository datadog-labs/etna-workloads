Comparisons in the select list / HAVING of an aggregate query must use the column's affinity and collation (TK_AGG_COLUMN in sqlite3ExprAffinity/collation).
repro.sql runs `a=123` (TEXT column), `b='456'` in HAVING, and a NOCASE `a='abc'` under GROUP BY.
The clean shell returns 1 / integer 456 / 1; the buggy shell returns 0 / no row / 0 (affinity and collation ignored).
