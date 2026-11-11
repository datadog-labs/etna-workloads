# Adapted injection for Better messages for next in a iterator inside for loops

Fix: https://github.com/rust-lang/rust/commit/44a8a8d0ca407a08612b87eaff1211dda1528633

Re-expresses the fix by removing the new diagnostic from both call sites (the parent behaviour had no such note/help).
- compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, report_conflicting_borrow: removed call to explain_iterator_advancement_in_for_loop_if_applicable (fix hunk `@@ -992,6 +993,11 @@` adding that call). Function kept with #[allow(dead_code)] to avoid unused warnings (the fix's hunk adding the function itself is not reversed).
- compiler/rustc_borrowck/src/diagnostics/mod.rs, explain_captures: removed the call before `let func = ...` (fix hunk `@@ -1146,6 +1146,12 @@`).
