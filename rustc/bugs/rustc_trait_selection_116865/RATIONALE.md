# Adapted injection for Suggest constraining assoc types in more cases

Fix: https://github.com/rust-lang/rust/commit/dee86bff4049692ba50122717131d58582e0f281

# Hunk: compiler/rustc_trait_selection/src/error_reporting/infer/note_and_explain.rs, fn suggest_constraint
Removed the tail that recursed into the parent trait/impl (the `parent_count` check, the `ImplItem`/`TraitItem` hir_id match, and `self.suggest_constraint(.. parent ..)`), now ending with `false`.
Re-expresses fix hunk `@@ -341,39 +341,48 @@` ("// If associated item, look to constrain the params of the trait/impl. ... self.suggest_constraint(diag, msg, parent.into(), proj_ty, ty)"), which added that recursion; before the fix it returned `false`.
The other fix hunk (callable_scope in expected_projection) was not re-injected.
