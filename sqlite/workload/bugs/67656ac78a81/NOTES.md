Reproducer (repro.sql): the transitive1-620 case. t0 has an index on b1; the query
`SELECT * FROM t0,t1 WHERE likely(b1=z3) AND a0=z3` should return no rows (a0=0, z3=1).
The buggy shell disables the index-driving term even though it comes from a transitive
constraint, so it wrongly returns the row `0|1|7|8|9|1`. The clean shell returns nothing.
