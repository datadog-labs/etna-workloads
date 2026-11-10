# Adapted injection for dont discard overflow from normalizes-to goals

Fix: https://github.com/rust-lang/rust/commit/4a38442c900bd859ecece400454d5abc56647b64

# Rationale

One hunk: `compiler/rustc_next_trait_solver/src/solve/eval_ctxt/mod.rs`, `evaluate_added_goals_and_make_canonical_response`.

The `(CurrentGoalKind::ProjectionComputeAssocTermCandidate, Certainty::Yes)` match arm now has the guard `if !goals_certainty.is_overflow()`. With the guard, a `NormalizesTo` goal whose nested goals overflowed falls through to the `_` arm. That arm yields an overflow certainty, and the existing `keep_constraints: false` block then returns an empty ambiguous response. The inference constraints of the normalizes-to goal are dropped.

This re-expresses the fix hunk in `eval_ctxt/canonical.rs`, `@@ -94,20 +94,6 @@`. That hunk removed the unconditional `if let Certainty::OVERFLOW = certainty { return Ok(self.make_ambiguous_response_no_constraints(MaybeCause::Overflow)); }`. The parent commit therefore always discarded constraints when a normalizes-to goal overflowed. The fix's other hunks (`instantiate_response_discarding_overflow` and `current_goal_is_normalizes_to`) added the "keep overflow constraints for normalizes-to unless ImplWhereBound" logic.

In 1.99.1 the code is structured differently. The solver now has a `keep_constraints` flag in `MaybeCause::Overflow`. Normalizes-to goals also hand their nested goals back to the caller (`NestedNormalizationGoals`) instead of evaluating them inside the goal. I therefore re-created the discard where overflow of a normalizes-to goal's nested goals is detected.

The earlier attempt, dropping the `keep_constraints: false` filter, did not fail any oracle case. The fix's other hunks (`GoalSource` threading and the doc comment) have no 1.99.1 counterpart to revert.
