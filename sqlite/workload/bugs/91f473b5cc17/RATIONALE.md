# Rationale

## src/whereexpr.c, isLikeOrGlob()
Reverses the single implementation hunk of the fix (ticket 0f0428096f17252a).
The fix added a special case: when the LIKE/GLOB prefix is just `-` (`iTo==1 && zNew[0]=='-'`),
treat it as numeric (`isNum = +1`) so the LIKE optimization is skipped for non-text columns.
I removed that branch and restored the old unconditional "increment last char, re-run
sqlite3AtoF, decrement" check. A lone "-" and "." ("-"+1 = ".") don't parse as numbers, so the
optimization is applied and the column is compared as a range `c0>='-' AND c0<'.'`,
which excludes numeric -1 (numbers sort before text).
The comment line citing the ticket was left in place (comment only).

## Oracle failures
`like3-5.420` fails: `SELECT * FROM t0 WHERE t0.c0 GLOB '-*'` on a no-affinity column holding -1
no longer returns `-1`. Only this one case fails (1 error out of 216); like3-5.421 passes because
the non-WHERE expression isn't affected by the optimization.
