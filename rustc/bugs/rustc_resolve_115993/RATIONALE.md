# Adapted injection for vis note for no pub reexports glob import

Fix: https://github.com/rust-lang/rust/commit/d0941f92d71effed03b29be468d3755acad42017

In 1.99.1 the lint is a derived diagnostic `RedundantImportVisibility` (the fix's BuiltinLintDiagnostics variant, to_string helper and ftl entry no longer exist as such), so the hunks were re-expressed there.

- compiler/rustc_resolve/src/diagnostics/mod.rs, struct `RedundantImportVisibility`: restored old message "glob import doesn't reexport anything because no candidate is public enough" (fix hunk `@@ -987,13 +987,23 @@ imports.rs`: new msg "... with visibility `{}` because no imported item is public enough") and removed the `#[note("the most public imported item is ...")]` / `#[help(...)]` (fix hunk `@@ -926,6 +926,10 @@ context.rs`, `RedundantImportVisibility { max_vis, span } => span_note/help`) and the max_vis/import_vis fields.
- compiler/rustc_resolve/src/imports.rs, the buffer_lint call: now passes unit struct `RedundantImportVisibility` (fix's removal of `max_vis.to_string(..)` diagnostic args / buffer_lint_with_diagnostic).
