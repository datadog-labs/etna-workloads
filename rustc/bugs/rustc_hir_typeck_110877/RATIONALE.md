# Adapted injection for Provide RHS type hint when reporting operator error

Fix: https://github.com/rust-lang/rust/commit/015acc261101aa7efcd3b72c31ff5f320dda65e3

# Rationale
compiler/rustc_hir_typeck/src/op.rs, `FnCtxt::lookup_op_method`, `None =>` arm: removed the block
that (after the delayed-bug) did `if let Some((rhs_expr, rhs_ty)) = opt_rhs && rhs_ty.is_ty_var() { self.check_expr_coercible_to_type(rhs_expr, rhs_ty, None); }`
(plus its comment, "Guide inference for the RHS expression..."). This re-expresses the fix hunk
`@@ -776,6 +776,19 @@ impl<'a, 'tcx> FnCtxt<'a, 'tcx>` which added that block. The delayed-bug (already present) was kept.
Effect: RHS type is not hinted when reporting an operator error, so messages lack the RHS type.
