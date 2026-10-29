repro.sql creates t1(a,b) and runs `SELECT a FROM t1 WHERE max(b)<10 GROUP BY a;` (ticket 1514, aggregate in WHERE).
Clean shell: "misuse of aggregate: max()" parse error, exit 1.
Buggy shell: the aggregate is accepted and the shell crashes (SIGSEGV, exit -11).
