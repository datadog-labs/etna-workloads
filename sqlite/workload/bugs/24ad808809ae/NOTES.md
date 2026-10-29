repro.sql compares a row value against a row-value sub-select whose column carries a COLLATE nocase, e.g. `('abc',1) = (SELECT 'ABC' COLLATE nocase, 1)`.

Clean: the sub-select's collation is ignored, so the comparison is binary and the output is `0`, then `1`, `0` for the table query.
Buggy: the sub-select's collation is used, so the output is `1`, then `1`, `1`.
