# Rationale

## Changed hunk
`src/src/smt/mam.cpp`, `interpreter::mk_depth2_vector`: removed the condition
`i < p2->get_num_args() &&` from the inner parent loop, just before
`p2->get_arg(i)->get_root() == p`.

Traces to the single hunk of FIX.diff (fix #2902), which added exactly that bounds check.
The reversed diff does not apply verbatim because the surrounding lines differ in this release
(the outer loop already has `p->get_num_args() > j2->m_arg_pos`), so the line was removed by hand.

Without the check, a flat-assoc/variadic parent p2 of function f with fewer than i+1 arguments
gets `get_arg(i)` called out of range. In this Debug build that trips the
`idx < get_num_args()` assertion in smt_enode.h:232. A release build would read out of bounds.

## Final ./check.sh output
BUILD OK
FAIL z3test:smt2/2902.smt2 (rc=110)
    1c1,5
    < unsat
    ---
    > ASSERTION VIOLATION
    > File: <z3-src>/src/smt/smt_enode.h
    > Line: 232
    > idx < get_num_args()
