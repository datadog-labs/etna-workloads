# Adapted injection for fix: improve missing value diagnostics for built-in attributes

Fix: https://github.com/rust-lang/rust/commit/30bc6d2f06c4641d10f44aae1f783d6e63c10e1c

compiler/rustc_resolve/src/late/diagnostics.rs, `make_base_error` (non-fallback branch, final `BaseError { .. }`):
`could_be_expr` changed from the computed parameter back to `could_be_expr: false`.
Re-expresses fix hunk `@@ -571,13 +551,37 @@` : `-                could_be_expr: false,` / `+                could_be_expr,`.
So the "you might have meant an expression" suggestions are lost for the non-type-namespace error path.
