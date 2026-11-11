Removed `set_model_completion(true)` calls, undoing the FIX.diff hunks that added them:
- opt_pareto.cpp (2 hunks): after `m_solver->get_model(m_model)` in the pareto loop and in `pareto_base::mk_pareto`/`mk_not_dominated_by` caller. Without completion, eval of the model leaves unassigned terms uncompleted, so the pareto loop does not terminate (z3 hangs on issue-1699.smt2).
- opt_context.cpp `get_model_core` hunk: removed `mdl->set_model_completion(true)` (in today's code it is guarded `if (mdl)`).
- opt_context.cpp validate-model hunk (`get_model(mdl); mdl->set_model_completion(true)`): removed.
Not reverted: the TRACE change in opt_context.cpp and the sine_filter.cpp iterator cleanups (no behavioural effect).

Final ./check.sh output:
FAIL z3test:smt2/issue-1699.smt2 (rc=137)   (z3 hangs, killed by 120s timeout; expected "sat / x = 0" model not printed)
