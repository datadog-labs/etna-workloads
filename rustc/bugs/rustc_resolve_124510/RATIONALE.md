# Adapted injection for Add raw identifier in a typo suggestion

Fix: https://github.com/rust-lang/rust/commit/589c2fe24d1f9e7bde8a50b07bb53eb4fbee6d8e

# Hunk
File: compiler/rustc_resolve/src/diagnostics/impls.rs (line ~2288, in the typo-suggestion builder, formerly diagnostics.rs).
Changed `suggestion.candidate.to_ident_string()` back to `suggestion.candidate.to_string()`.
Re-expresses fix hunk `@@ -1617,7 +1617,7 @@` in diagnostics.rs: `-(span, suggestion.candidate.to_string(), String::new())` / `+...to_ident_string()`.
Effect: raw identifiers lose their `r#` prefix in suggestions.
