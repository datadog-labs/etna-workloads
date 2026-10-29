repro.sql is whereL-400: a join with a duplicated WHERE constraint (`x.b = 1 AND x.b = 1`).
Correct result: no rows (x.b is 0). The buggy shell propagates the duplicate constraint twice
and returns a wrong row (or otherwise differs); see ./check.sh output.
