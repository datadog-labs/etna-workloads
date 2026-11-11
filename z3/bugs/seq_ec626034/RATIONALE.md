# Rationale

Hunk: src/src/ast/seq/seq_eq_solver.cpp, `eq_solver::can_align_from_lhs_aux`.

Traces to the only implementation hunk of FIX.diff (theory_seq::overlap, since moved/rewritten into
`can_align_from_lhs_aux`). The fix replaced the loop `for (j = i-1; rs.size()+j >= 1+i; --j)` comparing
`ls[j]` with `rs[rs.size()+j-i-1]` with a bounded loop `for (j = 0; same && j < i; ++j)` that handles the
`rs.size() > i` case. The old loop decrements an unsigned j past 0 when rs.size() > i+1, so it wraps and
indexes out of bounds. I restored that loop in place of today's two-branch bounded loops.

Result: issue-1725.smt2 hits an out-of-bounds vector access (assertion `idx < size()`) instead of printing `sat`.

Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/issue-1725.smt2 (rc=110)
    1c1,5
    < sat
    ---
    > ASSERTION VIOLATION
    > File: .../src/util/vector.h
    > Line: 369
    > idx < size()
