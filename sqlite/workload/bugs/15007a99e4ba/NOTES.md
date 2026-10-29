repro.sql: sorts 10 rows with ORDER BY x+1 and LIMIT 5 OFFSET -2.
The buggy shell adds the negative offset to the limit (5 + -2 = 3), so it returns
only 3 rows (0 1 2) instead of 5 (0 1 2 3 4) as the clean shell does.
