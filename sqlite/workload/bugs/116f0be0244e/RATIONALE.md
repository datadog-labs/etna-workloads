# Rationale

The fix changed `clearDatabasePage()` in `src/btree.c` so that a page listing itself as a child was not recursed into without end.

Version 3.54.1 no longer has the fix's `hasChildren` code. Two later guards in the same function now cover that case. I removed both:

- the `(freePageFlag>>1) > BTCURSOR_MAX_DEPTH` recursion-depth check
- the `sqlite3PagerPageRefcount(...) != (1 + (pgno==1))` check

Removing them puts back the pre-fix behaviour. A page that is its own child is recursed into again and again.

## Oracle result

`./check.sh` reports 4 of 5 cases in `test/corruptJ.test` failing: 1.2, 2.1, 2.2 and 2.2b. The run is incomplete because it crashes or hangs at 1.2, the DROP TABLE on the corrupted root page. Case 1.1 passes. Cases 2.1, 2.2 and 2.2b are counted as failing because the run never reaches them.
