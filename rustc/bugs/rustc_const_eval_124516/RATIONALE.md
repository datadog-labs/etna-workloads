# Adapted injection for Allow const eval failures if the cause is a type layout issue

Fix: https://github.com/rust-lang/rust/commit/4cf34cb75268d13a3ec08476058e96fb5b1c1eef

# Rationale
File: compiler/rustc_const_eval/src/const_eval/error.rs, fn report_validation/ error conversion (`err_inval!(Layout(LayoutError::ReferencesError(guar)))` arm).
Re-expresses fix hunk `@@ -139,9 +139,10 @@` which changed this arm to produce `ReportedErrorInfo::tainted_by_errors(guar)` (the "allowed" kind, in 1.99.1 `allowed_in_infallible`) instead of a plain `guar.into()`.
Bug: the arm now yields a plain (non-allowed) `ReportedErrorInfo::const_eval_error(guar)`, so `eval_mir_constant` in interpret/eval_context.rs (the fix's second hunk, already present as `is_allowed_in_infallible`) hits span_bug "not in required_consts" for layout errors. The other fix hunks (is_tainted_by_errors accessor, eval_context check) are already present in 1.99.1 and unchanged.
