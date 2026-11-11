# Adapted injection for trait_sel: don't require predicates of aliases hold

Fix: https://github.com/rust-lang/rust/commit/c50aebba78724edd395841f884998ddeddd659d4

# Rationale
Single hunk, `compiler/rustc_trait_selection/src/traits/select/confirmation.rs`, `confirm_projection_candidate`.
Re-expresses fix hunk `@@ -194,28 +192,6 @@` (removal of `// FIXME(compiler-errors): I don't think this is needed.` block `if let ty::Alias(ty::Projection, alias_ty) = placeholder_self_ty.kind() { ... predicates_of(...).instantiate_own ... }`) and the `@@ -144,8 +144,6 @@` hunk (removal of `let tcx = self.tcx();`).
Both are restored: after matching the candidate, for a projection self type, the alias's own predicates are normalized and pushed as nested obligations, so WF of an alias requires its predicates to hold.
Adapted to 1.99.1 API: `tcx.clauses_of(def_id)` instead of `predicates_of`, `ty::Alias(_, AliasTy { kind: AliasTyKind::Projection { def_id }, .. })` pattern.
