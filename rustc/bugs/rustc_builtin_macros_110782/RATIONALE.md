# Adapted injection for Revert "Remove #[alloc_error_handler] from the compiler and library"

Fix: https://github.com/rust-lang/rust/commit/f54dbe6e3116a475f63b580884f07474239a0b25

# Rationale
Hunk: compiler/rustc_builtin_macros/src/lib.rs (mod list and register_builtin_macros).
Removed `mod alloc_error_handler;` and the `alloc_error_handler: alloc_error_handler::expand,` registration.
Re-expresses fix.diff hunks for compiler/rustc_builtin_macros/src/lib.rs (the revert re-adds `mod alloc_error_handler;` at @@ -20 and the `alloc_error_handler: alloc_error_handler::expand,` entry at @@ -107). The parent commit had removed the attribute macro, so `#[alloc_error_handler]` no longer expands.
Other parts of the original removal (metadata, codegen, library) were not touched; the macro removal alone is enough to bring back the buggy behaviour.
