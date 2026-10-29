repro.sql runs `SELECT * FROM j1 WHERE (select min(a) FROM j1) IN (?, ?, ?)` (the test added by the fix, rowvalue-8.1).
Clean shell: no output, exit 0. Buggy shell: assertion failure `exprAnalyze: Assertion `0' failed` (abort).
The injected condition treats a scalar sub-select on the LHS of IN as a row value in exprAnalyze.
