Changed hunk: src/src/opt/opt_solver.cpp, opt_solver::get_model_core.
Traces to the single FIX.diff hunk, which added an early return of the preferred "last model" at the start of get_model_core. In today's code that early return is `if (m_model.get()) { m = m_model.get(); return; }`; I removed it, so the most recent model is no longer preferred and an older per-objective model is returned (issue #5710).
Result: z3test:smt2/5710.smt2 now FAILS (assertion violation in maxcore.cpp:261).
    > Line: 261
    > !m_model->is_false(m_asms) || m.limit().is_canceled()
    > (C)ontinue, (A)bort, (S)top, (T)hrow exception, Invoke (G)DB, Invoke (L)LDB
