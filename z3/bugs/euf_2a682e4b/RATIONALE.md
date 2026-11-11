# Rationale (all changes in src/src/ast/euf/euf_egraph.cpp)

1. update_children(): removed the m_updates.push_back(update_record(n, update_children())).
   Traces to FIX.diff hunk 1 (egraph::update_children adds that undo record). Without it,
   parents added by update_children are never popped on backtrack, leaving stale parent
   entries (the #5482 bug); the test now hits an assertion in the egraph.
2. set_cgc_enabled()/toggle_cgc_enabled(): restored the pre-fix scheme (merge done inline in
   set_cgc_enabled instead of queued via m_to_merge in the toggle; contains_ptr instead of is_cgr).
   Traces to FIX.diff hunks on set_merge_enabled/toggle_merge_enabled (names are cgc in today's code).
   Not what makes the test fail by itself.

Final ./check.sh output:
BUILD OK
FAIL z3test:issues/5482.smt2 (rc=110)
