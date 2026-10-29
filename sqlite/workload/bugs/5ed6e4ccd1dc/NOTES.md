repro.sql is joinI-7.0/7.1: a RIGHT JOIN with an index on an expression (t2(d, e+1)) and a WHERE on that expression.

Clean prints `|2|555`. Buggy also prints `|3|3`, a wrong extra row. Without the fix, the index cursor isn't set to a NULL row before the RIGHT JOIN's scan of the right-hand table, so the expression is read from a stale index entry.

I ran both shells directly because `./check.sh` failed in this sandbox (bwrap couldn't find `.claude/launch.json`). The outputs above come from those direct runs.
