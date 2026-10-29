# RTRIM collation bug (CVS 5010)

Fix hunk: src/main.c `allSpaces()` changed from `while( n>0 && z[--n]==' ' ){}` to
`while( n>0 && z[n-1]==' ' ){ n--; }`. The buggy version decrements `n` even when it
sees a non-space, so a one-character non-space remainder (e.g. "e") was judged "all spaces".

In 3.54.1 `allSpaces()` no longer exists; `rtrimCollFunc` was rewritten to strip trailing
spaces from both keys and then call sqlite3BinaryCompare. To restore the bug I put back
the old structure in src/main.c: memcmp of the common prefix, then `allSpaces()` (with the
buggy `z[--n]` loop) on the longer key's remainder. The only defect is the `--n` loop;
the rest is the old comparison shape needed to host it.

Oracle failures (test/collateA.test): collateA-1.17, 1.21, 1.23, 2.17, 2.21, 2.23
(e.g. `c='abcd'` wrongly matches 'abcde', since the 1-char remainder 'e' is treated as spaces).
date.test: no failures (its changes only add coverage).
