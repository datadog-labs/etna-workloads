# Rationale

Changed hunk: `src/src/ast/rewriter/finite_set_rewriter.cpp`, `finite_set_rewriter::mk_union`.
Traces to the FIX.diff hunk in `finite_set_rewriter.cpp` that adds `mk_union`'s
idempotency rule `set.union(x, x) -> x`. The fix introduced the rewriter's basic rules, and
today's code still has them. I removed the idempotency check, so `set.union(x,x)` is no longer
simplified. This is the same missing-simplification bug. The other union rules are untouched.

Final ./check.sh output:
BUILD OK
FAIL finite_set_rewriter (rc=114)
    ASSERTION VIOLATION  src/src/test/finite_set_rewriter.cpp Line 46: Failed to verify: st == BR_DONE
