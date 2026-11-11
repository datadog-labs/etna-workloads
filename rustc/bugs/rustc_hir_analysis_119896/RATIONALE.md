# Adapted injection for Taint `_` placeholder types

Fix: https://github.com/rust-lang/rust/commit/4586fdce47e70ed4fe8568a6578bde2ed9faa31e

# Rationale
File: compiler/rustc_hir_analysis/src/collect.rs, `lower_fn_sig` (moved from astconv/mod.rs in the fix).
Two hunks, re-expressing fix hunks `@@ -2543,7 +2543,11 @@` (input `_`: `return Ty::new_error_with_message(...)` -> `return suggested_ty;`) and `@@ -2561,7 +2565,7 @@` (output `_`: error type -> `suggested_ty`).
The `_` placeholder is no longer tainted with an error type; the suggested type is used, so later checks see an untainted, mismatched signature (ICE 119867).
