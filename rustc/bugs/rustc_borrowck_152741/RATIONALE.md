# Adapted injection for Suppress invalid suggestions in destructuring assignment

Fix: https://github.com/rust-lang/rust/commit/115bfdbb35014162be380f061ee08691f2503601

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/move_errors.rs, fn `add_move_error_details`.
Re-expresses the last fix hunk (`@@ ... fn add_move_error_details(`):
`-if let Some(expr) = self.find_expr(binding_span) { ... suggest_cloning` vs
`+if !desugar_spans.contains(&binding_span) { if let Some(expr) ...`.
The guard that skips the clone suggestion for destructuring-assignment desugar bindings is removed
(`desugar_spans` is ignored), so an invalid `.clone()` suggestion is emitted again for `Thing(*&mut String::new()) = ...`.
Other fix hunks (BindingFinder collection) are left intact; they now only feed an unused value.
