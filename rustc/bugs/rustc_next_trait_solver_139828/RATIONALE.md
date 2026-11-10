# Adapted injection for Don't require rigid alias's trait to hold

Fix: https://github.com/rust-lang/rust/commit/bb3c98165cca752ba93927f19fa3f78c48caccc7

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/normalizes_to.rs (file was `normalizes_to/mod.rs` upstream), fn `compute_normalizes_to_goal` (the rigid-alias fallback closure passed to `assemble_and_merge_candidates`).

Re-expresses the fix hunk `@@ -45,7 +45,6 @@` which removed
`this.add_goal(GoalSource::AliasWellFormed, goal.with(cx, trait_ref));`
after `instantiate_normalizes_to_as_rigid`. I re-added that line, so a rigid alias again requires its trait ref to hold.
