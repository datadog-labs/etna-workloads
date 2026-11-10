# Adapted injection for diagnostics: avoid mismatch between variance index and hir generic

Fix: https://github.com/rust-lang/rust/commit/3799af3337d748647ca6c4abbad63975275a7a37

# Rationale
File: compiler/rustc_hir_analysis/src/check/wfcheck.rs, fn check_variances_for_type_defn.
Removed the block comparing `tcx.generics_of(..).own_params[index]` with `hir_generics.params[index]` (and its delayed bug + `continue`).
Re-expresses fix hunk `@@ -1762,13 +1764,32 @@ fn check_variances_for_type_defn`, which added the ty_param/hir_param mismatch check.
Without it, the variance index (ty-generics order: lifetimes first) indexes hir generics (source order), so with `struct Foo<T, 'a>` the wrong param (`'a`) is reported instead of `T`.
