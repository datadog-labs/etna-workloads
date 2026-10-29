repro.sql: FULL OUTER JOIN whose left side is `t1 JOIN v2 ON 0` (join-29.1).
The injection drops the ON-clause check in sqlite3ExprAnd(), so "AND false"
is folded away even for ON-clause terms.
Clean prints `NULL|NULL|1`; buggy prints no rows (wrong result).
