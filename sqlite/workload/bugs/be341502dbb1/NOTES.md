Reproducer (repro.sql): join5-11.2 translated to SQL. A LEFT JOIN with fake sqlite_stat1 rows
makes the Bloom-filter optimization kick in, and the WHERE term `d IS NULL` on the right table
is wrongly treated as "self-culling".

`SELECT count(*) FROM t1 LEFT JOIN t2 ON c=b WHERE d IS NULL;`
- clean: 4
- buggy: 8 (wrong result)
