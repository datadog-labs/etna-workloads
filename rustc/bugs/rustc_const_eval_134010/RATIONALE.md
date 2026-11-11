# Adapted injection for fix ICE on type error in promoted

Fix: https://github.com/rust-lang/rust/commit/ed8ee39930a1bc0b436a67b7189b79466a514bae

Bug: type-error (tainted) errors were classified as `allowed_in_infallible: false` (old `From<ErrorGuaranteed>`), so a type error in a promoted ICEs instead of being suppressed.
Re-expressed by switching the call sites back to `ReportedErrorInfo::const_eval_error` (the old `.into()` behaviour):
- rustc_const_eval/src/interpret/eval_context.rs (`mir_for_ctfe`-ish tainted check, and instance resolution error): fix hunks `@@ -268,7 +268,7 @@` (`non_const_eval_error(err)` replacing `ReportedErrorInfo::from(err)`) and `@@ -317,7 +317,9 @@`.
- rustc_middle/src/mir/consts.rs (`Const::eval` unevaluated ty::Const delayed bug): hunk `@@ -331,7 +332,10 @@`.
- rustc_middle/src/mir/interpret/queries.rs (`const_eval_resolve` resolution Err): hunk `@@ -81,7 +82,9 @@`.
