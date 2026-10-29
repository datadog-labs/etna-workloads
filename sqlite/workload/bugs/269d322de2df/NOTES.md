Reproducer (repro.sql): a vector comparison `(t0.c0, 0) < ('B' COLLATE NOCASE, 0)` in WHERE on a UNIQUE-indexed column.
The COLLATE on the first term of the vector must be honored. Clean shell prints `1` and `2`; buggy shell prints only `1`
(the WHERE query returns no row, because the index is used with the wrong collation).
