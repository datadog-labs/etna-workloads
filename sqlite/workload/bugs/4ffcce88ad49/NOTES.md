Reproducer: LEFT JOIN with a WHERE of `CASE WHEN t2.b THEN 0 ELSE 1 END`.
The injected bug makes the outer-join strength-reduction prover treat CASE as implying a non-null row, so the LEFT JOIN is turned into an inner join.
Clean shell returns `3|NULL`; the buggy shell returns no rows.
