# Adapted injection for Detect calls to `.clone()` on `T: !Clone` types on borrowck errors

Fix: https://github.com/rust-lang/rust/commit/2d3435b4df844bb0c25b86bb73519a3c867a92a0

In compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, removed the two calls to `self.suggest_copy_for_type_in_cloned_ref(&mut err, place)` (in report_use_while_mutably_borrowed-style path after add_explanation_to_diagnostic, and at the end of report_borrowed_value_does_not_live_long_enough/conflicting borrow path after suggest_using_local_if_applicable). This re-expresses the fix hunks adding `+        self.suggest_copy_for_type_in_cloned_ref(&mut err, place);` (twice). The helper is kept with #[allow(dead_code)] so it builds. Result: no "this call doesn't do anything" label nor Clone bound/derive suggestion.
