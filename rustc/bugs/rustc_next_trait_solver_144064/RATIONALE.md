# Adapted injection for trait_sel: prefer only nested alias bounds

Fix: https://github.com/rust-lang/rust/commit/676d9cfa8bc6f2406d0d7ed8cd0d5eae74254bec

# Rationale
Both edits re-express the fix's "prefer only non-nested (SelfBounds) alias bounds for Marker-mode preference" by removing the SelfBounds restriction (parent behaviour: any alias bound, nested or not, beats where-bounds).

1. compiler/rustc_trait_selection/src/traits/select/mod.rs, `candidate_should_be_dropped...` / winnow function (ProjectionCandidate preference). Re-expresses hunk `@@ -1880,14 +1886,24 @@`: the fix added `.filter_map(|(idx, kind)| (kind == AliasBoundKind::SelfBounds).then_some(idx))` in the Marker branch; now `.map(|(idx, _)| idx)`.
2. compiler/rustc_next_trait_solver/src/solve/trait_goals.rs, merge_trait_candidates. Re-expresses hunk `@@ -1381,22 +1383,21 @@`: fix's `matches!(c.source, CandidateSource::AliasBound(AliasBoundKind::SelfBounds))` in the Marker check is now `AliasBound(_)`.
