# Adapted injection for Handle inference variables in CollectAllMismatches correctly

Fix: https://github.com/rust-lang/rust/commit/959616ef44fe919f297bba1c3ddc65bd8f2432fc

# Rationale
CollectAllMismatches no longer exists in 1.99.1; mismatches are now collected in
`compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs` (point_at_chain caller, the loop zipping where_pred/failed_pred trait-ref args and calling `.at(..).eq(..)`).

Hunk: before the `self.probe(...eq...)`, skip a pair when either type is an inference variable, including integer/float vars (`is_ty_or_numeric_infer`).
Re-expresses fix hunk `@@ -55,7 +55,7 @@ fn tys`: `if a.is_ty_infer() || b.is_ty_infer() { Ok(a) }` (fixed to `is_ty_var()`), i.e. the buggy version treated `{integer}` as an unconstrained infer var and reported no mismatch, so the `{integer}` note disappears.
