repro.sql mirrors indexA.test section 6 (6.0, 6.1, 6.6, 6.7): t1/t2 with partial index t2z, faked
sqlite_stat1 so the planner uses a bloom filter on t2, then a second partial index t2yz(y,z) WHERE y=5,
then `t1 LEFT JOIN t2 ON (y=5) WHERE b=1 AND z IS c`.

Clean shell returns 2 rows (1|1|1|1|5|1 and 2|1|2|2|5|2). The buggy shell returns no rows, because
sqlite3ConstructBloomFilter no longer saves/clears Parse.pIdxPartExpr.
