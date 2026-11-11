# Adapted injection for don't bail when encountering many placeholders

Fix: https://github.com/rust-lang/rust/commit/919b61a6f4aa2e0002c01037d923c68c57f47f33

# Rationale
Fix hunk: `@@ -173,7 +173,8 @@` in canonical.rs (old path), changing
`filter(|c| !c.is_region())` to `filter(|c| !c.is_region() && c.is_existential())`
so placeholders aren't counted toward the recursion-limit bail.

In 1.99.1 the whole bail was gone (file moved/rewritten). I re-added the pre-fix
behaviour in `compiler/rustc_next_trait_solver/src/solve/eval_ctxt/mod.rs`,
`evaluate_added_goals_and_make_canonical_response`, after `canonicalize_response`:
for non-NormalizesTo goals (`!is_normalizes_to_goal` equivalent: current_goal_kind
!= ProjectionComputeAssocTermCandidate), count `canonical.var_kinds` with only
`!c.is_region()` (placeholders counted), and if > recursion_limit return an
overflow ambiguous response with no constraints.
