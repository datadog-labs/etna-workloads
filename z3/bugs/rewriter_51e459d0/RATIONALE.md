# Rationale (fix #3294)

Two hunks, both undoing implementation hunks of FIX.diff:

1. src/src/ast/rewriter/th_rewriter.cpp (reduce_quantifier, generic update_quantifier branch):
   removed `if (m().proofs_enabled() && q1 != old_q) p1 = m().mk_rewrite(old_q, q1);`
   Traces to the th_rewriter.cpp hunk of FIX.diff. Without it, when proofs are enabled and the
   quantifier is rebuilt, no proof step old_q -> q1 is recorded, so the transitivity chain built later
   has mismatched facts (assertion `fact1->get_arg(1) == fact2->get_arg(0)` in ast.cpp).
   This is what makes z3test smt2/3294.smt2 fail.

2. src/src/ast/rewriter/rewriter_def.h (process_quantifier, rewrite_patterns branch):
   restored indexed copy `new_pats[i] = np[i]` / `new_no_pats[i] = nnp[i]` instead of compacting
   with j + shrink + updating num_pats/num_no_pats. Traces to the rewriter_def.h hunk of FIX.diff.
   (Today's code also had an extra verbose message in the pattern loop, which is dropped along with the loop rewrite.)
   Note: this hunk alone did not make the test fail.

Final ./check.sh output:
    1c1,5
    < unsat
    ---
    > ASSERTION VIOLATION
    > File: .../src/src/ast/ast.cpp
    > Line: 2884
    > fact1->get_arg(1) == fact2->get_arg(0)
(FAIL for z3test:smt2/3294.smt2; build OK.)
