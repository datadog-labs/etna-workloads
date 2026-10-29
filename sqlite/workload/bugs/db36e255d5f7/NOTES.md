Reproducer (`repro.sql`): TEXT PRIMARY KEY table with one row `''`, then the
row-value comparison `(t0.c0, TRUE) > (CAST('' AS REAL), FALSE)` in a WHERE clause.

Clean shell prints `1` and `2`. Buggy shell prints only `1`: the WHERE query
returns no row, because the row-value comparison is wrongly used with the
index even though the right-hand side's affinity (REAL) does not match the
index column's (TEXT).
