# Rationale

Hunk traced: FIX.diff, quasi_macros.cpp `apply_macros`, where `new_prs.push_back(ps)` (a proof variable
that was never set) became `new_prs.push_back(pr)`. That code has since been rewritten into
`apply_macros(expr_ref_vector&, proof_ref_vector&, ...)`.

Today's equivalent: in src/src/ast/macros/quasi_macros.cpp `apply_macros`, `prs[i] = pr;` was changed to
`prs[i] = prr;`. This stores the wrong proof variable, the rewriter's proof instead of the macro-expansion
proof. The result is a proof that does not match the formula, as in the original bug. With `(set-option :proof true)`
this trips `f == m().get_fact(pr)` in goal.cpp:257 on 3670.smt2.

The other hunks in FIX.diff are a pure rename of `m_manager` to `m` and cosmetic changes, so they have no behavioural counterpart.

## Final ./check.sh output
BUILD OK
FAIL z3test:smt2/3670.smt2 (rc=110)
    1c1,5
    < sat
    ---
    > ASSERTION VIOLATION
    > File: .../src/tactic/goal.cpp
    > Line: 257
    > f == m().get_fact(pr)
