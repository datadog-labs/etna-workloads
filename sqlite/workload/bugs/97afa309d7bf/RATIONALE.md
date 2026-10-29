# Rationale

Fix hunk (src/whereexpr.c, isLikeOrGlob): the pre-fix code only ran the "does the
pattern prefix look like a number" check when the first character was a digit, '-'
or '+', or when the prefix was one char that sorts just before '0' (`zNew[0]+1=='0' && iTo==1`).
The fix replaced the last clause with `iTo>0 && zNew[iTo-1]=='0'-1`, so a prefix ending in
'/' (e.g. './') is also caught.

In 3.54.1 the check was generalised: the whole numeric test runs unconditionally for any
non-TEXT-affinity LHS (and tests the end boundary by incrementing the last char). I restored the old
gate in front of that block: the check only runs if first char is digit/'-'/'+' or
(`zNew[0]+1=='0' && iTo==1`) -- the pre-fix (buggy) form of the condition. A prefix like './'
with a non-TEXT-affinity column (INT, NOCASE) is again not checked, so the LIKE optimization is
applied and the range-scan result is wrong.

Oracle failures: like3-5.400 (`SELECT * FROM t0 WHERE t0.c0 LIKE './'` returns no row) and like3-5.410.
