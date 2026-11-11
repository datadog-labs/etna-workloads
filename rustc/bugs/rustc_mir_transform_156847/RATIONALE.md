# Adapted injection for Fix suggestion of unused variables with raw identifier in struct pattern

Fix: https://github.com/rust-lang/rust/commit/8604f001a96a05f58cadfb4695b39e9458ac3f1e

Fix moved errors.rs -> compiler/rustc_mir_transform/src/diagnostics.rs.
1. diagnostics.rs, UnusedVariableSugg::TryIgnore: `name: String` -> `name: Symbol` (fix hunk @@ -290,7 `-name: Symbol, +name: String`). Symbol displays without `r#`.
2. liveness.rs (~1142): `name: name.to_ident_string()` -> `name` (fix hunk @@ -1068 in AssignmentResult). Suggestion becomes `move: _` instead of `r#move: _`.
