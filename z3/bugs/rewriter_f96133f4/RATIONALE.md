Traces to the bit_blaster_rewriter.cpp hunks of FIX.diff (m_shifts member, push in reduce_quantifier's
binding loop, shrink, and the reduce_var rewrite). I removed the m_shifts tracking and restored the
pre-fix reduce_var (plain lookup of m_bindings, no var shifting for nested quantifiers / free vars),
keeping the later is_bv check. Nested quantifier bit-blasting then substitutes unshifted bindings: wrong de Bruijn indices (issue #1729).
Other FIX.diff hunks (api_goal, z3_api.h docs, goal::is_literal) not touched.
Final check.sh: BUILD OK; FAIL z3test:smt2/issue-1729.smt2 (output differs from expected).
