repro.sql runs `select * from (select * from topk limit 8) order by x limit 3` with target_partitions=4.
Clean returns 3 rows (0,1,2). Buggy drops the ORDER BY's fetch in EnforceSorting, so it returns 8 rows (0..7).
