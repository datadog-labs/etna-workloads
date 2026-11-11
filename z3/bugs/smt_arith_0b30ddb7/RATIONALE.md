# Rationale
Changed hunk: src/src/smt/theory_lra.cpp, max_result(), case lp_status::FEASIBLE: removed `blocker = mk_gt(v, term_max);`.
Traces to the single implementation hunk of FIX.diff, which added `blocker = mk_gt(v)` in the FEASIBLE case of maximize (previously a "todo" with no blocker set). In today's code that logic lives in max_result; removing the assignment leaves the blocker unset for FEASIBLE results, as before the fix, so the optimizer gets no blocking constraint and returns a wrong optimum.

Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/issue-1733.smt2 (rc=0)
    2c2
    < ((s26 1))
    ---
    > ((s26 0))
