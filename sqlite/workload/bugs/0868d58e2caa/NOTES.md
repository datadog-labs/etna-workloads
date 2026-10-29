repro.sql deletes all rows from t1 with a RETURNING clause containing subqueries on t1.
Clean shell recomputes them per row (max(a)/count shrink: 1|3|2, 2|3|1, 3|N|0 style);
the buggy shell treats them as uncorrelated and computes once, so every row shows the same values.
