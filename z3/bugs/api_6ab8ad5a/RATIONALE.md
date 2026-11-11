Changed hunks (all in src/src/api):
- api_tactic.cpp (FIX.diff hunk): Z3_apply_result_get_subgoal bounds check `i >= size` -> `i > size`; index == size passes the check (off-by-one).
- api_datatype.cpp (hunk): removed the `num_fields > accs.size()` check in Z3_query_constructor so the loop reads past the accessor vector.
- api_algebraic.cpp (hunk): removed `a != nullptr` in Z3_algebraic_is_value_core, so NULL ast is dereferenced.

check.sh result:
FAIL api (rc=110)
FAIL api_algebraic (rc=139)
PASS box_independent
PASS box_mod_opt
PASS fpa
PASS max_rev
PASS opt_dup_min
PASS scaled_min
