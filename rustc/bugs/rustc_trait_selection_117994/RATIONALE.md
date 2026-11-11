# Adapted injection for Ignore but do not assume region obligations from unifying headers in negative coherence

Fix: https://github.com/rust-lang/rust/commit/488dcb7af3fc394ca438da2a9fe8a40dcae06948

# Rationale
File: compiler/rustc_trait_selection/src/traits/coherence.rs, fn impl_intersection_has_negative_obligation.

Fix hunk `@@ -408,7 +408,7 @@ fn impl_intersection_has_negative_obligation` and `@@ -416,6 +416,13 @@`: the fix renamed `_equate_obligations` to `equate_obligations` and added
`drop(equate_obligations); drop(infcx.take_registered_region_obligations()); drop(infcx.take_and_reset_region_constraints());`
(plus the take_registered_region_assumptions in 1.99.1) after equating headers. I removed these drops (restoring `_equate_obligations`), so region constraints from unifying headers (e.g. `T: '!0`) are kept as requirements when proving negated where clauses.
The third fix hunk only removed a FIXME comment in try_prove_negated_where_clause; not needed (comment-only, already absent in 1.99.1).
