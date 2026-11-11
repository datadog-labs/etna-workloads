# Adapted injection for Don't ICE if method receiver fails to unify with arbitrary_self_types

Fix: https://github.com/rust-lang/rust/commit/05c5caa5002297d2e3ba31f2ead7556a732a2289

# Rationale
File: compiler/rustc_hir_typeck/src/method/confirm.rs, fn `unify_receivers`.
Re-expresses the fix hunk `@@ -482,13 +482,22 @@` (`Err(_) => span_bug!(...)` replaced by `Err(terr)` with an
`arbitrary_self_types` branch calling `report_mismatched_types`). The Err arm now unconditionally calls `span_bug!`
(an ICE) when the receiver fails to unify, even with arbitrary_self_types enabled.
The first fix hunk (cause span `self.span` -> `self.self_expr.span`) was not re-injected. It affects only the error span.
