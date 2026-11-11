# Adapted injection for Don't assume traits used as type are trait objs

Fix: https://github.com/rust-lang/rust/commit/9a2772e1c2d6e770e13716d4691bc0a943cd7d61

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs, `lower_trait_object_ty`.
Re-expresses the fix hunk in hir_ty_lowering/mod.rs (`@@ -2063,13 +2063,18 @@`, `if let Some(guar) = self.prohibit_or_lint_bare_trait_object_ty(hir_ty) { ... Ty::new_error(tcx, guar) }`).
In 1.99.1 that logic moved here. The buggy (pre-fix) behaviour: the result of the bare-trait check (E0782 error guarantee) is ignored and lowering continues as a trait object, instead of returning `Ty::new_error`. This causes the confusing follow-up errors/ICEs.
