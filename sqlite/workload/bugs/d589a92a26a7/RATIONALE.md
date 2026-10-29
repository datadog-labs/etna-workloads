# ROUND() returns TEXT instead of REAL (ticket #1699)

Fix hunk reversed: `src/func.c` roundFunc, `sqlite3_result_text(zBuf)` -> `sqlite3_result_double(atof(zBuf))`.

In 3.54.1 roundFunc has a fast path for n==0 and a "%!.*f" + sqlite3AtoF path, both ending in
`sqlite3_result_double`. I replaced both with the pre-fix behaviour: always format with
`sqlite3_mprintf("%.*f", n, r)` and return it via `sqlite3_result_text(..., SQLITE_TRANSIENT)`,
freeing the buffer afterwards (the old code used a stack buffer). The NULL check was only
reordered by the fix (no behaviour change), so it is untouched.

## Oracle
test/func.test: round() now yields text like "1.23" / "2.00" / "-2.00" rather than reals
(func-4.x round tests, typeof(round(...)) = 'text' instead of 'real'). The test run aborts early
at the first mismatch, so almost all func.test cases are reported as failing.
