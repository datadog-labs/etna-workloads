# Rationale

All changes are in `ext/fts5/fts5_main.c`.

1. `fts5SpecialMatch`: removed `n==5 &&` from the "reads" test and `n==2 &&` from the "id" test. This reverses fix hunks 1 and 2. The `strnicmp` calls are again prefix matches, so `'*'` (n==0) matches "reads".
2. `fts5ApiCallback`: the condition is `pCsr==0` again, not `pCsr==0 || (pCsr->ePlan==0 || pCsr->ePlan==FTS5_PLAN_SPECIAL)`. This reverses fix hunk 3. 3.54.1 also rejects `FTS5_PLAN_SPECIAL` here, which is the same defect, so I reverted that too.

## Oracle
fts5misc.test fails from 1.1.1 on. 1.1.1 and 1.1.2 give the wrong error ("no such cursor: 0" instead of "unknown special query"). 1.2.1 hits the assertion `pCsr->ePlan!=FTS5_PLAN_SPECIAL` in `fts5ApiInvoke`, which aborts the run. Without asserts this would be a crash.
