# Adapted injection for avoid overlapping privacy suggestion for single nested imports

Fix: https://github.com/rust-lang/rust/commit/73030143818b99f0180a259b161cacd175b7d775

# Rationale
compiler/rustc_resolve/src/diagnostics/impls.rs, privacy error reporting (call to import_candidates, ~line 2595):
`DiagMode::Import { append: single_nested, .. }` -> `append: false`.
Re-expresses fix hunk `@@ -1775,7 +1775,7 @@` (`-DiagMode::Import,` / `+DiagMode::Import { append: single_nested },`).
Before the fix, the append mode did not exist, so single nested imports (`use a::{b::C}`) always got the replacing
suggestion (overlapping span) instead of the appended help text. The rest of the machinery (append variant, show_candidates) is kept.
