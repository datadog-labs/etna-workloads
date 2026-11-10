# Adapted injection for Suggest removing superfluous semicolos when statements used as expressions

Fix: https://github.com/rust-lang/rust/commit/e6f48fa0bb2c66bb29661bc81d4df5fadad32515

File: compiler/rustc_trait_selection/src/error_reporting/infer/mod.rs, in note_type_err: removed the call `self.suggest_turning_stmt_into_expr(cause, &exp_found, diag);`.
Re-expresses fix hunk `@@ -1976,6 +1976,7 @@ impl<'tcx> TypeErrCtxt` in rustc_infer error_reporting/mod.rs, which added `self.suggest_for_statments_as_exp(cause, &exp_found, diag);` (function now named suggest_turning_stmt_into_expr). Without it, no semicolon-removal suggestion for `let x = if .. { 3; } else { 4; }; x`.
