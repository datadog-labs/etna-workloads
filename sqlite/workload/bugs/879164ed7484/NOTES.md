repro.sql: t1.b is COLLATE nocase, t2.d is binary; a UNION ALL subquery is filtered with b='BbB'.
The WHERE is pushed into each compound arm; the clean shell gives the row `1|bbb` (nocase applies via the
subquery column's collation), the buggy shell returns no rows because the pushed-down term in the t2 arm
uses binary collation.
