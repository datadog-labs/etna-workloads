repro.sql runs the two failing cases (minmax4-4.1 and 5.1) from the test: `SELECT MIN(a) FROM t1 WHERE a=123` with an index on (a, b DESC), and `SELECT MIN(c1), c0 ... WHERE c1 ISNULL` with an index on (c1, c1+1 DESC).
The clean shell returns `123` and `|1`. The buggy shell wrongly skips past NULLs in the min() scan and returns an empty row for each (`` and `|`).
