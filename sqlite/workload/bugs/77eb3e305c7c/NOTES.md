Reproducer: `format('%,.249f', -5.0e-300)` (printf-18.1). The injection drops the `e2>0`
guard on the thousands-separator buffer-size adjustment, so for a tiny value (negative e2)
the temp buffer is undersized.
Clean shell prints 252; the buggy shell aborts with
`Assertion 'length <= szBufNeeded' failed` (exit -6).
