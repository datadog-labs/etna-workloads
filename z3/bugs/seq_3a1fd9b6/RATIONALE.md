Changed hunk: src/src/ast/rewriter/finite_set_rewriter.cpp, mk_app_core.
Traces to FIX.diff hunk "@@ -41,6 +42,12 @@" which added dispatch of OP_FINITE_SET_MAP / OP_FINITE_SET_FILTER to mk_map / mk_filter.
The mk_map/mk_filter functions already exist in this release (with slightly different local-variable style), so the diff cannot be reversed verbatim; I removed the two dispatch cases. set.map/set.filter over empty/singleton/union are then no longer eliminated by the rewriter, so the axioms are reached (the original bug: divergence on concrete sets).

Final ./check.sh output:
BUILD OK
FAIL finite_set_rewriter (rc=114)
    ASSERTION VIOLATION
    File: src/src/test/finite_set_rewriter.cpp  Line: 363
    Failed to verify: st == BR_DONE
