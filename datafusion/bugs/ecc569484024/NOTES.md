Reproducer for the FULL OUTER JOIN + LIMIT pushdown bug (#14335).

repro.sql writes two CSV files (1..5 and 5..1), registers them as external
tables t1/t2, and runs `SELECT * FROM t1 FULL JOIN t2 ON t1.a = t2.b LIMIT 2`
with target_partitions = 1. A limit pushed into both join inputs makes the
join see mismatched rows.

- df-clean: returns (5,5) and (4,4).
- df-buggy: returns (NULL,5) and (NULL,4), which is wrong.

The final EXPLAIN is included but its output is the same on both builds.
