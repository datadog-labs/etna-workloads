# Adapted injection for Add note for identifier with attempted hygiene violation

Fix: https://github.com/rust-lang/rust/commit/12cde3091a5d258c2f3e140e47537818680cb58d

# Rationale
File: compiler/rustc_resolve/src/late/diagnostics.rs, function `smart_resolve_context_dependent_help` (the E0425/E0412 branch).
Removed the call `self.suggest_ident_hidden_by_hygiene(err, path, span);`, re-expressing fix hunk
`@@ -1125,6 +1125,8 @@` (which added that call). The helper (fix hunk `@@ -1138,6 +1140,28 @@`) is kept but marked
`#[allow(dead_code)]` so the build stays warning-free; it is never invoked, so the "identifier exists but is not accessible due to macro hygiene" help is lost (pre-fix behaviour).
