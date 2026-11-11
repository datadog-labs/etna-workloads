# Adapted injection for Don't ICE because recomputing overflow goals during find_best_leaf_obligation causes inference side-effects

Fix: https://github.com/rust-lang/rust/commit/d3e510eb9dcb81059d5bc31cbbf212b8d96537cf

All changes are in compiler/rustc_trait_selection/src/solve/fulfill/derive_errors.rs (code moved there from fulfill.rs).

1. `fulfillment_error_for_stalled`: the overflow arm returns `true` instead of `false` for `refine_obligation`, so overflowing goals are recomputed in `find_best_leaf_obligation`. Re-expresses fix hunk `@@ -244,16 +244,23 @@` (`false,` with "Don't look into overflows").
2. `BestObligation::non_trivial_candidates`, `consider_ambiguities == true` arm: restores the old filter. It keeps only candidates with `Ok(Certainty::Maybe(_))`, and when there is more than one candidate it keeps those with an ambiguous nested where-bound goal. The fix replaced this with `candidates.retain(|c| c.result().is_ok())`. Re-expresses hunk `@@ -302,41 +313,50 @@`.
3. `BestObligation::visit_goal`: matches `Ok(Certainty::Maybe(_))` instead of only `MaybeCause::Ambiguity`, so overflow goals get visited. Re-expresses hunk `@@ -401,7 +421,10 @@` (`Maybe(MaybeCause::Ambiguity)`).
