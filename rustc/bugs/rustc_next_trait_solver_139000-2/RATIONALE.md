# Adapted injection for Rigidly project missing item due to guaranteed impossible sized predicate

Fix: https://github.com/rust-lang/rust/commit/27836e1e5794dfa8db8565adaf7aed05d8bfff92

# Rationale
1.99.1 already refactored the fix (`impl_self_is_guaranteed_unsized` query replaces `is_guaranteed_unsized_raw`), so I disabled the guaranteed-unsized branch at both sites with `false &&`, restoring the pre-fix behaviour.

- compiler/rustc_trait_selection/src/traits/project.rs, `confirm_impl_candidate`: re-expresses fix hunk `@@ -2011,19 +1994,47 @@ fn confirm_impl_candidate` (`if tail.is_guaranteed_unsized_raw() { return Ok(Projected::NoProgress(..)) }`). Now a missing item always yields a misc-error Progress instead of a rigid projection.
- compiler/rustc_next_trait_solver/src/solve/normalizes_to.rs, missing-item branch: re-expresses `@@ -232,7 +232,17 @@` (`if goal_trait_ref.self_ty().is_guaranteed_unsized_raw() {..rigid..} else { delay_bug("missing item") }`). Now always `delay_bug("missing item")`.
