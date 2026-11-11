# Adapted injection for Simple modification of diagnostic information

Fix: https://github.com/rust-lang/rust/commit/4897d5eccf642d701263d8d3ae63d9276810a494

# Rationale
File: compiler/rustc_ast_passes/src/diagnostics.rs (struct `ForbiddenBound`, in 1.99.1 messages are inline, errors.rs/messages.ftl no longer exist).
Changed `#[diag("bounds cannot be used in this context")]` back to `#[diag("lifetime bounds cannot be used in this context")]`.
Re-expresses fix hunks in messages.ftl (`-ast_passes_forbidden_lifetime_bound = lifetime bounds cannot be used in this context` / `+ast_passes_forbidden_bound = bounds cannot be used in this context`) and errors.rs (`@@ -52,8 +52,8 @@` `-#[diag(ast_passes_forbidden_lifetime_bound)]`). The fix generalised the message because type binder bounds (issue #119067) are also reported by this diagnostic.
