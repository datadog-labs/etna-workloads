# Rationale
Changed hunk: src/src/sat/sat_solver.cpp, `solver::invoke_local_search`.
Traces to the single implementation hunk of FIX.diff, which added `if (inconsistent()) return l_false;` at the start of invoke_local_search (fix #3220). In today's code the check sits after `scoped_ls _ls(*this);`; I removed those two lines (the check). Without it, local search runs on an already-inconsistent solver (the `(and (xor a b) a b)` case), so it reports a bogus result and model validation prints "unsat clause" instead of the expected output.

Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/3220.smt2 (rc=0)
    0a1,2
    > unsat clause
    > 1 2  <= 1 lhs value: 2
