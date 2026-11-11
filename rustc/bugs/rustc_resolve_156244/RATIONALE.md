# Adapted injection for address review comment

Fix: https://github.com/rust-lang/rust/commit/05b97f76a48d2550038144347decb0151d7c4709

# Rationale
One hunk: compiler/rustc_resolve/src/diagnostics/impls.rs, `report_privacy_error` (moved from diagnostics.rs in 1.99.1), the non-`self`/`super` branch that builds suggestion paths from `import.module_path`.
Added `.skip(1)` before the `PathRoot` filter. This re-expresses fix hunk
`@@ -2429,7 +2429,7 @@` : `-for segment in import.module_path.iter().skip(1) {` / `+for segment in &import.module_path {`.
The first segment (e.g. `crate`) is dropped, so suggestions become `use one::One;` instead of `use crate::one::One;`.
The other fix hunks (single_nested ordering) are already refactored into `can_replace_use` with equivalent behaviour, so not reverted.
