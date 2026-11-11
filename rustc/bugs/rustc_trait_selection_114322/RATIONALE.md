# Adapted injection for Fix invalid slice coercion suggestion reported in turbofish

Fix: https://github.com/rust-lang/rust/commit/87e8feaf507054a2403cd983e444c9de5ec1ca64

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn `suggest_convert_to_slice` (formerly maybe_suggest_convert_to_slice).
Removed the early return `let (BinOp | FunctionArg) = obligation.cause.code() else { return; }`, which re-expresses the fix hunk
`@@ -3957,10 +3958,17 @@ fn maybe_suggest_convert_to_slice` (added `let ObligationCauseCode::FunctionArgumentObligation { .. } = obligation.cause.code() else { return; };`).
Without it the slice suggestion is emitted for turbofish/call obligations. The `obligation` param is renamed `_obligation` (unused) to avoid warnings.
