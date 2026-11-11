# Adapted injection for Suggest a borrow when using dbg

Fix: https://github.com/rust-lang/rust/commit/317952677ad6a80b3751a075f42ffd2a8d142a84

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, fn suggest_ref_or_clone.
Removed the call `self.suggest_ref_for_dbg_args(expr, place, move_span, err);` added by the fix hunk
`@@ -546,7 +547,14 @@` (the `+ self.suggest_ref_for_dbg_args(...)` line), restoring the pre-fix behaviour where no
`dbg!(&x)` borrow suggestion is emitted. The helper fn (fix hunk `@@ -561,6 +569,59 @@`) is kept with
`#[allow(dead_code)]` to avoid an unused warning. Other fix hunks (imports, is_imported check) already present/unrelated.
