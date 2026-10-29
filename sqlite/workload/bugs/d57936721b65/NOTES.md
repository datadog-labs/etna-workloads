repro.sql: LEFT JOIN with ON 0 and `WHERE (b IS NOT NULL)=0`.
Clean shell returns `1|` (one row, b NULL). Buggy shell treats IS NOT NULL as implying
a non-NULL row, so the LEFT JOIN is wrongly strength-reduced to an inner join and no rows are returned.
