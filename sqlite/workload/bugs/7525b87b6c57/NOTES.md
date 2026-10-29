repro.sql: table t5 with expression indexes on abs(a) and abs(b), then
`SELECT * FROM t5 WHERE abs(a)=2 OR abs(b)=9`.
Clean prints `2|4` and `3|9`. The buggy shell treats the OR as an IN on one
expression (it doesn't compare the two expressions) and aborts with an assertion
failure in exprAnalyzeOrTerm (exit 134).
(check.sh failed here on a sandbox bwrap error, so I ran both shells by hand.)
