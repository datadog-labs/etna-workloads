# Rationale
Hunk: src/src/ast/ast.cpp, basic_decl_plugin::mk_func_decl, case OP_DISTINCT.
Traces to the FIX.diff hunk adding the sort-mismatch check for `distinct` (the fix throws ast_exception on mismatched argument sorts).
In today's code that check became a loop that coerces the domain with join() and reports an error for incompatible sorts. I removed that loop, so `distinct` is built with unchecked, mismatched domains, which is the pre-fix behaviour.
The api unit's test_mk_distinct (bv8 vs bv32) no longer triggers the error callback, so `SASSERT(cb_called)` fails.
The other FIX.diff hunks (the mk_distinct move to ast.cpp, and the test) are not behavioural, so I did not change them.

check.sh: FAIL api (ASSERTION VIOLATION api.cpp:260 cb_called); PASS box_independent box_mod_opt max_rev opt_dup_min scaled_min
