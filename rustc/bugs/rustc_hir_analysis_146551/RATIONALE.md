# Adapted injection for fix issue with `cmse-nonsecure-entry` ABI being both async and c-variadic

Fix: https://github.com/rust-lang/rust/commit/8b752cb37d646118c46f7739ae965b8e9c9a9b03

# Hunk: compiler/rustc_hir_analysis/src/hir_ty_lowering/cmse.rs, validate_cmse_abi
Removed the early return for c-variadic `cmse-nonsecure-entry` fns (`if decl.c_variadic() { return; }`, in 1.99.1 a method rather than field).
Re-expresses fix hunk `@@ -85,6 +85,12 @@ pub(crate) fn validate_cmse_abi` which added `if decl.c_variadic { return; }` (issue #132142).
