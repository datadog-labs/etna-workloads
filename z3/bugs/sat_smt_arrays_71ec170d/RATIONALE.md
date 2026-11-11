Changed hunk: src/src/sat/smt/array_axioms.cpp, `solver::assert_default_store_axiom` (small-domain branch).
Traces to the array_axioms.cpp hunk of FIX.diff: restores the pre-fix code, i.e. the reversed pairing
(B[eps] paired with default(A), store[eps] with default(B)), the short-circuiting `||` of the two
propagate_axiom calls, and drops the diagonal axiom A[diag(i)] = B[diag(i)] (diag unused again).
This yields the incorrect default/model consistency, so the issue #10981 regression test in smt_context fails.
Other hunks (model_evaluator, check_const_arrays) were not reverted (minimal change).

Final ./check.sh: BUILD OK; FAIL smt_context (rc=114) ASSERTION VIOLATION smt_context.cpp:57 l_true == slv->check_sat
