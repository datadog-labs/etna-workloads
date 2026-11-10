# Adapted injection for fix accidental type variable resolution in array coercion

Fix: https://github.com/rust-lang/rust/commit/b235cc22acdde9be7a25c3b5828e9c5863a0b54f

# Rationale
File compiler/rustc_hir_typeck/src/expr.rs, fn check_expr_array. Re-expresses fix hunk
`@@ -1670,11 +1670,22 @@ impl<'a, 'tcx> FnCtxt<'a, 'tcx>`: removed the
`.filter(|t| !self.try_structurally_resolve_type(expr.span, *t).is_ty_var())` (in 1.99.1 it is
`resolve_vars_with_obligations`), so the expected element type var is used directly as coerce_to
and gets resolved by the first coercion instead of the LUB. Comment-only hunks not reverted.
