# Adapted injection for Always register sized obligation for argument

Fix: https://github.com/rust-lang/rust/commit/0d6da78b06e0fa4e1df1fe6795f3e17f0320071a

# Rationale
File: compiler/rustc_hir_typeck/src/check.rs, fn check_fn.
Re-expresses the fix hunk `@@ -92,10 +92,7 @@ pub(super) fn check_fn`: the fix removed
`param.pat.simple_ident().is_none() && !params_can_be_unsized` -> `!params_can_be_unsized`.
Here I restored the `param.pat.simple_ident().is_none() &&` guard (wrapping the 1.99.1 condition
`!params_can_be_unsized || abi == RustTail`), so simple-ident params no longer register a Sized obligation.
