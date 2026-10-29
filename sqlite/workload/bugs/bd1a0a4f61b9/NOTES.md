`repro.sql` runs `SELECT * FROM t1 ON 1=0` and `SELECT * FROM t1 USING(a)`, with no JOIN before the ON/USING.
Clean shell: "Parse error: a JOIN clause is required before ON/USING", exit 1.
Buggy shell: the clause is silently dropped, so the queries return a row (1) and exit 0.
