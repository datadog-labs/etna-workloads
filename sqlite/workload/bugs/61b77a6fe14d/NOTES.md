Bare column `a` (NOT NULL) of an aggregate query over an empty table evaluates to NULL.
The buggy shell applies the NOT NULL strength reduction outside the WHERE clause, so
`a IS NULL, a IS NOT NULL` returns `0|1|0`; the clean shell returns the correct `1|0|0`.
