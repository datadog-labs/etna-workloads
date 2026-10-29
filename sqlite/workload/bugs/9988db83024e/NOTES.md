repro.sql: t1 has one row (x='AAA', y='BBB'), so x=y is false. The query
`SELECT * FROM t1 JOIN t2 ON unlikely(x=y) AND y='AAA'` (and the `likely` form) must return no rows.
The buggy shell returns the non-matching row `AAA|BBB|t2`. Constant propagation plus transitive-term
handling wrongly derives x='AAA' from the fixed-column term and drops the x=y check.
The clean shell prints nothing.
