# Adapted injection for Forbid the use of `#[target_feature]` on `main`

Fix: https://github.com/rust-lang/rust/commit/db266939822a5a89473871abff6beea39b083af6

# Rationale
File: compiler/rustc_hir_analysis/src/check/entry.rs, fn check_main_fn_ty (moved from lib.rs in 1.99.1).
Removed the block rejecting `#[target_feature]` on `main` (emit `TargetFeatureOnMain` when `codegen_fn_attrs(main).target_features` is non-empty, with wasm/rustdoc exemptions added later).
Re-expresses fix hunk `@@ -283,6 +283,11 @@ fn check_main_fn_ty` in lib.rs:
`+    if !tcx.codegen_fn_attrs(main_def_id).target_features.is_empty() { ...emit_err(errors::TargetFeatureOnMain ...`.
The error struct/ftl message are left in place (unused struct is still fine).
