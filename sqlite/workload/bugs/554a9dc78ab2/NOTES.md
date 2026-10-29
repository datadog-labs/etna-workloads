repro.sql runs `UPDATE t1 SET (a,a,a,b)=(SELECT 99,100)`. The target list has 4 columns and the subquery returns 2.

- Clean shell: `Parse error near line 3: 4 columns assigned 2 values`, exit status 1.
- Buggy shell: the injection stops recording the column count, so the mismatch isn't reported. The VDBE then hits `Assertion 'memIsValid(pRec)' failed` and the shell aborts (exit status -6).
