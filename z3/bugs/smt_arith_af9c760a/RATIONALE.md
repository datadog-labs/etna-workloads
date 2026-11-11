# Rationale

FIX.diff has one hunk: in theory_lra.cpp it removes `ctx().get_rewriter()(modmq);` from the mod/div axiom code. The old code no longer exists in this release. The same axiom is now built as `a.mk_le(a.mk_add(mod, minus_q), mone)`, with no rewriting.

Changed hunk (src/src/smt/theory_lra.cpp, ~line 1502): the `mod_lt_q` axiom term `mod + (-1*q)` is now put in `modmq` and passed through `ctx().get_rewriter()` before `mk_literal`. This is the rewriter call the fix removed. The rewritten term yields an inconsistent literal and an invalid model, which is the #6670 failure.

Caveat: this re-adds the call that the fix removed. It is not a literal revert, because the surrounding code has been restructured since.

## check.sh output
BUILD OK
FAIL z3test:smt2/6670.smt2 (rc=1)
    1a2
    > (error "line 4 column 10: an invalid model was generated")
