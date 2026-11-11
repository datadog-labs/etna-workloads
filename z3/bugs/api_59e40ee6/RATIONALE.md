Changed hunk: src/src/api/api_datatype.cpp, Z3_query_constructor — removed the `num_fields > accs.size()` check (Z3_INVALID_ARG) added by the only implementation hunk of FIX.diff. Without it, num_fields beyond constructor arity reads accs[i] out of bounds (vector idx assertion), the bug the fix removed. The subgoal check in api_tactic.cpp is not in the implementation part of FIX.diff, so untouched.

check.sh result:
FAIL api (rc=110)
PASS box_independent
PASS box_mod_opt
PASS max_rev
PASS opt_dup_min
PASS scaled_min
