# Adapted injection for Check def id before calling match_projection_projections

Fix: https://github.com/rust-lang/rust/commit/43dae6934153693be62902fcefed0f97b4ca892f

# Rationale
File: compiler/rustc_trait_selection/src/traits/project.rs, fn `assemble_candidates_from_trait_def`.
Removed the early-continue `if clause.item_def_id() != obligation.predicate.expect_projection_def_id() { return ControlFlow::Continue(()); }` before `match_projection_projections`.
Re-expresses fix hunk `@@ -793,6 +793,9 @@ fn assemble_candidates_from_trait_def`, which added
`if clause.projection_def_id() != obligation.predicate.def_id { return ControlFlow::Continue(()); }` (renamed in 1.99.1).
