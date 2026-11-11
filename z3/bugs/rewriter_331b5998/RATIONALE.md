Changed file: src/src/ast/rewriter/array_rewriter.cpp (mk_eq_core), tracing to FIX.diff hunks 2-4 (the expand_store hunk was not touched; today's code differs).
- Removed the `if (m().is_uninterp(d)) continue;` skips in has_large_domain and domain_is_larger_than (FIX hunks 2,3): uninterpreted domains are again treated as large/infinite, so const-array equalities with stores over an uninterpreted sort get rewritten as if the domain could not be covered by the stores (sat/unsat wrong for singleton domains).
- Removed the block that expands stores into lambdas when const arrays have an uninterpreted domain (FIX hunk 4, in today's code with the has_value_indices guard).
Final ./check.sh: BUILD OK; FAIL smt_context (rc=114) assertion at smt_context.cpp:207 (expected == check_sat).
