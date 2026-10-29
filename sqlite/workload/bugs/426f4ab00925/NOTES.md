Table t14(a,b) with index on (b,a); `SELECT min(a) FROM t14 WHERE b='2' AND a>'50'`.
The min() optimization must apply integer affinity to the lower-bound constraint; the buggy shell
keeps bSeekPastNull set, so the result differs from the correct 100 (see check.sh output).
