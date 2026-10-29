repro.sql: t1(x,y) has rows (1,NULL),(2,NULL),(1,NULL) and a UNIQUE index on (x,y).
`SELECT DISTINCT x, y` must return 2 rows. The injected bug removes the NOT NULL
check in the distinct-via-unique-index optimization, so the buggy shell treats
the index as unique despite NULLs and returns all 3 rows (duplicate 1|).
