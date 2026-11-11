# Adapted injection for Allow dropping dyn principal

Fix: https://github.com/rust-lang/rust/commit/e3800a1a04f338ce69bd403f230a019cebc54ece

# Hunks
1. compiler/rustc_trait_selection/src/traits/select/candidate_assembly.rs, assemble_candidates_for_unsizing (dyn->dyn): removed `|| principal_def_id_b.is_none()`. Re-expresses fix hunk `@@ -1018,7 +1018,7 @@` (`if principal_def_id_a == principal_def_id_b || principal_def_id_b.is_none()`). Dropping the principal is no longer treated as a trivial auto-trait-only unsize in the old solver.
2. compiler/rustc_next_trait_solver/src/solve/trait_goals.rs, consider_builtin_dyn_upcast_candidates: restored `if a_data.principal_def_id() == b_data.principal_def_id()`. Re-expresses fix hunk `@@ -785,7 +785,8 @@` (added `b_principal_def_id.is_none()`).
