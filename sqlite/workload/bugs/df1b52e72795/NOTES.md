repro.sh builds t1(x INTEGER PRIMARY KEY, y) with a unique index on y, plus t2, and fakes sqlite_stat1 so the planner uses the OP_SeekScan optimization. It then reopens the database so the stats load, and runs `SELECT t1.x FROM t2 CROSS JOIN t1 WHERE t2.z = t1.y AND t1.x IN (111,222)`.

Clean prints `222` and `111`. Buggy prints only `222`, because the index cursor still points at a valid row on the first iteration of the inner loop, so OP_SeekScan skips a seek. The fix adds an OP_NullRow before the loop.
