Changed src/src/sat/smt/fpa_solver.cpp, solver::internalize(expr*, bool sign, bool root): returns expr2literal(e) without negating when sign is set.
This undoes the fpa_solver.cpp hunk of FIX.diff, which added `if (sign) lit.neg();`. The wrong polarity makes z3test issues/5429.smt2 print sat instead of unsat.
The array_solver.cpp hunk was not undone: the call to propagate_parent_select_axioms is already unconditional in this release, and removing it would be a different change.
Final ./check.sh: the z3test:issues/5429.smt2 unit FAILS (sat vs expected unsat).
