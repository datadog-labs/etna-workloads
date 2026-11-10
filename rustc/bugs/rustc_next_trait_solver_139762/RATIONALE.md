# Adapted injection for Don't assemble non-env/bound candidates if projection is rigid

Fix: https://github.com/rust-lang/rust/commit/e882ff4e7ebc4653cdc69e57bc656fe558a4af88

# Rationale

1. `assembly/mod.rs`, `assemble_and_merge_candidates` (ParamEnv|AliasBound arm).
   Re-expresses fix hunk `@@ -782,47 +803,44 @@ merge_candidates -> assemble_and_merge_candidates`, where the fix
   calls `assemble_and_evaluate_candidates(goal, AssembleCandidatesFrom::EnvAndBounds)`
   so impl/builtin/object candidates are never assembled for rigid projections.
   Buggy version: assemble with `AssembleCandidatesFrom::All` (impls included, as pre-fix
   `assemble_and_evaluate_candidates(goal)` did) and then `retain` only ParamEnv/AliasBound candidates.

2. `normalizes_to.rs`, impl candidate (`consider_impl_candidate`): removed the early
   `ecx.try_evaluate_added_goals()?` bail. In 1.99.1 this bail is a separate later
   mitigation for the same RPITIT query cycle (trait-system-refactor-initiative#185) that
   masked the bug once impl candidates were assembled again; without removing it the
   pre-fix cycle (fix hunk `@@ -288,6 +288,21 @@` doc: "required to prevent query cycles due to RPITIT inference") is not reproducible.
