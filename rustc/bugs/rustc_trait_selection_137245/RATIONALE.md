# Adapted injection for Tweak E0277 when predicate comes indirectly from `?`

Fix: https://github.com/rust-lang/rust/commit/e565eeed78d0e59e475dce34b0833bbf8f84871b

All changes in compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs, report_selection_error.

1. `let is_question_mark = ...` replaced by `false`. Re-expresses fix hunk `@@ -192,19 +192,38 @@` which added `is_question_mark` (QuestionMark cause, excluding FromResidual/Try) and its branch "`?` couldn't convert the error: ... is not satisfied". Without it the old generic message is used (the new test fails).
2. Removed `&& !self.tcx.is_diagnostic_item(sym::FromResidual, leaf_trait_predicate.def_id())` from the `err.help(explanation)` condition. Re-expresses hunk `@@ -302,10 +327,14 @@`; the "FromResidual is not implemented" help reappears.
