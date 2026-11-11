# Adapted injection for fix: naming convention "ferris" suggestion for idents named 🦀

Fix: https://github.com/rust-lang/rust/commit/ec88bc2e00985e99923ff3de966a947daa63c567

# Rationale
The fix added context-sensitive Ferris suggestions; the buggy parent always suggested `ferris`.
- compiler/rustc_interface/src/diagnostics.rs, `FerrisIdentifier`: re-expresses fix hunk `@@ -24,8 +24,9 @@ pub struct FerrisIdentifier` — restored `code = "ferris"` and removed the `ferris_fix` field.
- compiler/rustc_interface/src/passes.rs, `early_lint_checks`: re-expresses hunk `@@ -301,8 +301,41 @@ fn early_lint_checks` — removed the `FerrisFix` enum and the `span_to_prev_source` match, and emit `FerrisIdentifier { spans, first_span }`.
