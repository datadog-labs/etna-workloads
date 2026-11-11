Changed src/src/nlsat/nlsat_explain.cpp and nlsat_solver.cpp, undoing the cancellation-safe cleanup hunks of FIX.diff:
- explain: removed the on_scope_exit(reset_result) guards in test_root_literal, compute_conflict_explanation, main_operator/project etc., so duplicate marks (m_already_added) and m_result are not cleaned if cancellation throws mid-explanation (stale marks suppress required literals on retry).
- solver: removed the else branch in scoped_reset_marks destructor (reset_marks when m_num_marks==0), so marks of literals already in the lemma stay set after cancellation.
Result (check.sh):
PASS 13
FAIL nlsat (rc=110)
FAIL opt_pareto (rc=110)
PASS opt_pareto_long
