# Adapted injection for Feed `ErrorGuaranteed` from late lifetime resolution to RBV

Fix: https://github.com/rust-lang/rust/commit/c43a33eec7b29a637ff8a41804d30e679092bad9

# Rationale
1. compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs, `visit_lifetime` (resolve_lifetime_ref dispatch).
   Re-expresses hunk `@@ -891,8 +891,10 @@`: the fix replaced `hir::LifetimeKind::Error => {}` with
   `Error(guar) => self.insert_lifetime(lifetime_ref, ResolvedArg::Error(guar))`. Reverted to ignoring the error lifetime (`Error(..) => {}`), so RBV no longer records the guarantee.
2. compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs, `lower_trait_object_lifetime`.
   Re-expresses hunk `@@ -451,17 +451,7 @@`: restores the removed "Parent lifetime must have failed to resolve" hack (checks `named_bound_var(parent_lifetime.hir_id).is_none()`), which is only a partial suppression of E0228 and fails for e.g. `Ref<'undefined, dyn Debug>`.
The ErrorGuaranteed plumbing in late.rs/ast_lowering was left intact (it is harmless without RBV consuming it).
