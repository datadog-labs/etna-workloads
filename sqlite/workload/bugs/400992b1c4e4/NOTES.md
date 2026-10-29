Reproducer: INSERT INTO t1 SELECT 1,2 UNION ALL VALUES(3,4),(5,6) (values-12.2).
With the bug, the insert uses the VALUES co-routine shortcut even though the
SELECT has a prior compound term, so the rows come out wrong (see check.sh output). Clean gives 1|2, 3|4, 5|6.
