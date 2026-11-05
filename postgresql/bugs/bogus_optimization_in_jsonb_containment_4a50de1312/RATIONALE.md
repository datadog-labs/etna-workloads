# Rationale

Changed file: `src/backend/utils/adt/jsonb_op.c`, functions `jsonb_contains` and `jsonb_contained`.

Traces to the two jsonb_op.c hunks of fix.patch, which removed `JB_ROOT_COUNT(val) < JB_ROOT_COUNT(tmpl) ||` from the early-exit test. I put it back in both functions.

Why this brings the bug back: for arrays, the root count is not a valid bound. The right-hand side may contain duplicate elements, and a single left-hand element can satisfy several of them. For example, `'[1]' @> '[1,1]'` should be true, but the early exit returns false. Only objects can use a pair-count check, because their keys are de-duplicated.

I did not change the `JsonbDeepContains` hunk in jsonb_util.c. It adds an object-only `nPairs` check, and that check was already there. It is a safe optimization, not part of the bug.

Failing oracle case: `src/test/regress||jsonb`
