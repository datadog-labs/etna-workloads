# Adapted injection for Handle recursion limit for subtype and well-formed predicates

Fix: https://github.com/rust-lang/rust/commit/942e93972d316d59632be072506930e0e063bd17

All changes are in compiler/rustc_trait_selection/src/traits/fulfill.rs, in `FulfillProcessor::process_obligation`.

1. Removed the general-case overflow check arm (`_ if !...recursion_limit().value_within_limit(obligation.recursion_depth) => report_overflow_obligation`) that sat before the WellFormed arm. It re-expresses the fix hunk `@@ -410,6 +411,29 @@` that added "General case overflow check" with `report_overflow_error`. Without it, WellFormed and Subtype obligations never hit the recursion limit, so well-formed-recursion-limit.rs hangs.
2. The Subtype arm's `Ok(Ok(ok))` now builds pending obligations directly, with no `set_depth_from_parent`. It re-expresses the fix hunk `@@ -440,7 +464,12 @@`, which added `subobligation.set_depth_from_parent(obligation.recursion_depth)`. The sub-obligations restart at depth 0, so the limit is never reached (subtype-recursion-limit.rs).
The fix's third hunk only moved the Ambiguous and AliasRelate arms, which is not behavioural, so it was skipped.
