# Rationale
FIX.diff hunk (fpa_solver.cpp, solver::activate): added `else if (m.is_ite(n)) { /* pass */ }` so ite terms of
float/rm sort are not wrapped/unwrapped (`unwrap(wrap(n)) = n`). In today's code that ite handling lives in two
guards: `if (m.is_ite(n)) // skip` at the top of solver::activate, and `if (m.is_ite(n->get_expr())) return;` in
solver::apply_sort_cnstr. I removed both, so ite terms go through the generic float path again (the pre-fix bug).
Result: issues/5454.smt2 fails (z3 dumps core instead of printing sat x5).

Final ./check.sh output:
BUILD OK
FAIL z3test:issues/5454.smt2 (output: "timeout: the monitored command dumped core" vs expected "sat" x5)
