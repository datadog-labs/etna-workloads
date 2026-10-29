Adds a column with DEFAULT 2 to a populated t1, then runs `INSERT INTO t2 SELECT * FROM t1` into a plain t2(a,b).
Clean shell: prints `1|2`. Buggy shell: xfer optimization copies raw records (missing column b), so t2.b reads as NULL: `1|`.
The injection removes the check that default values of 2nd+ columns match.
