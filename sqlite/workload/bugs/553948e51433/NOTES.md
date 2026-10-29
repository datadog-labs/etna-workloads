`repro.sql` runs `SELECT min(sum(a)) OVER () FROM t1` (window4/window9 aggregate-inside-window case, no GROUP BY).
Clean shell prints `4`; buggy shell fails with `misuse of aggregate: sum()` (exit 1), because the window rewrite loses SF_Aggregate.
