# Rationale

Changed file: src/src/tactic/arith/eq2bv_tactic.cpp. It maps to the implementation hunks of FIX.diff.

- `is_bound` takes an `unsigned& k` out-parameter again. This undoes the hunks that changed `is_upper`, `is_lower`, `is_bound` and `collect_fd` to drop `k`.
- In the main rewrite loop, the model-converter value is the constant `val` found in the bound formula being deleted. It is inserted as `rational(val)`. This undoes the hunk that replaced it with a lookup of the real bound (`m_bounds.has_upper`/`has_lower`) and added the `has_val` check. The bug is the same: the formula is replaced by true, but the value recorded for the variable comes from that single bound formula. It is not a value consistent with all the bounds, so the model is invalid.
- Not reverted: the `vector<rational>` type of `m_values`, and the `ast_pp.h` include. The first is harmless on its own, since `rational(val)` still fits it. The second has no behavioural effect.

## check.sh output
BUILD OK
FAIL z3test:smt2/3715.smt2 (rc=1)
    1a2
    > (error "line 8 column 10: an invalid model was generated")
