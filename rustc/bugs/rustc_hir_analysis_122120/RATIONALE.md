# Adapted injection for Suggest assoc ty bound on bare dyn trait in eq constraint

Fix: https://github.com/rust-lang/rust/commit/22b9e960d9357f83110d42a31b7a2d47e6ae25e5

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs, in the bare-trait-object lint/error path (was lint.rs in the original fix).
Removed the call `self.maybe_suggest_assoc_ty_bound(hir_id, &mut diag);`.
This reverses fix hunk `@@ -64,10 +64,12 @@` which added `self.maybe_suggest_assoc_ty_bound(self_ty, &mut diag);` after `maybe_suggest_blanket_trait_impl`.
The helper itself is left in place (now unused), mirroring the pre-fix state where the suggestion was never emitted. The other two hunks were FIXME comments only.
