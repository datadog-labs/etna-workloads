# Adapted injection for diagnostics: suggest changing `s@self::{macro}@::macro` for exported

Fix: https://github.com/rust-lang/rust/commit/e9d8d238ef76c7991b316bbfbd9f857d84bd39cf

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs, fn check_for_module_export_macro (moved from diagnostics.rs).
Re-expresses both hunks of fix.diff (`@@ -2125,9 +2125,31 @@` and `@@ -2139,6 +2161,12 @@`):
- Removed `is_definitely_crate` (self/super check) and its use in the `if ... && let Ok(start_snippet)` condition.
- Removed the `else` branch that pushed a separate `use {module_name}::{import_snippet};\n` correction for module-relative imports.
Result: for `pub use self::{nu, ..}` the suggestion is mangled as `self::{nu, ...}` rewrite rather than a separate `use ::nu;`.
