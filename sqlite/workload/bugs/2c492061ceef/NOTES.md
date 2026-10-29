repro.sql: LEFT JOIN with WHERE CASE WHEN FALSE THEN a=x ELSE 1 END (join-15.100).
Clean returns both t1 rows with NULL t2 columns; the buggy shell treats the CASE as
implying t2.x is not NULL, strength-reduces the LEFT JOIN to an inner join, and returns no rows.
