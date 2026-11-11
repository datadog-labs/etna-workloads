# Adapted injection for Check sig for errors before checking for unconstrained anonymous lifetime

Fix: https://github.com/rust-lang/rust/commit/6ffe6dd826d737daf363c1251621b7da362a437d

# Hunk
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `lower_fn_ty`.
Replaced `if !fn_ptr_ty.references_error() {` with a bare `{` block, so the E0581 unconstrained-late-bound-region check runs even when the signature already contains errors.
Re-expresses fix hunk `@@ -2557,27 +2557,29 @@`, which wrapped the check in `if !bare_fn_ty.references_error()`.
