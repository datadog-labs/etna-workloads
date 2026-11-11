# Adapted injection for Reject escaping bound vars in the type of assoc const bindings

Fix: https://github.com/rust-lang/rust/commit/0b2fb8db6540b0548230cd335e7b2a845686f7ea

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/bounds.rs, fn check_assoc_const_binding_type (moved from astconv/bounds.rs).
Changed the early-return guard `if !ty.has_param() && !ty.has_escaping_bound_vars()` back to `if !ty.has_param()`.
Re-expresses fix hunk `@@ -552,17 +554,23 @@ fn check_assoc_const_binding_type`: `-    if !ty.has_param() {` / `+    if !ty.has_param() && !ty.has_escaping_bound_vars() {`.
Without it, types with only escaping late-bound vars (e.g. `for<'a> Trait<'a, C = { &0 }>`) are no longer rejected (the old FIXME(fmease) behaviour).
