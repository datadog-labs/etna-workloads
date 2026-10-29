Reproducer: `repro.sql` (tkt2822-5.1). `SELECT a AS b FROM t3 ORDER BY b` on t3(a,b) with rows (1,8),(9,2).
ORDER BY must resolve `b` to the result-set alias (a), so the clean shell returns 1, 9.
The buggy shell resolves it to column t3.b and returns 9, 1.
