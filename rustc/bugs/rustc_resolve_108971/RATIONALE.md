# Adapted injection for error-msg: impl better suggestion for `E0532`

Fix: https://github.com/rust-lang/rust/commit/bd1732240b586733d8d9fb47cf9ef4cfc299c22e

compiler/rustc_resolve/src/late/diagnostics.rs, smart_resolve_context_dependent_help (struct-pattern suggestion for E0532):
the fix hunk `@@ -1289,25 +1289,41 @@` added `old_fields` (snippets of the tuple-pattern args) and emitted `new: old` when names differ.
Re-injected the parent behaviour: field list is always `format!("{f}{tail}")`, ignoring the user's sub-patterns
(`old_fields` is now unused, renamed `_old_fields`). Suggestion becomes `FooB { x, y }` instead of `FooB { x: a, y: b }`.
