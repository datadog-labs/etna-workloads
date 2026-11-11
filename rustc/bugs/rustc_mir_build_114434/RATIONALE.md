# Adapted injection for Improve spans for indexing expressions

Fix: https://github.com/rust-lang/rust/commit/5706be1854db74d0aafcc4658423884689f139e9

# Rationale
File: compiler/rustc_mir_build/src/thir/cx/expr.rs, `Cx::make_mirror_unadjusted`, `hir::ExprKind::Index` arm.
Re-expresses the fix hunk `@@ -469,11 +469,17 @@ impl<'tcx> Cx<'tcx>`:
`-self.overloaded_place(expr, expr_ty, None, Box::new([lhs, index]), expr.span)` / `+... brackets_span`.
The overloaded index call's fn_span is again the whole indexing expression instead of just `[idx]`, so
panic locations and diagnostics for overloaded indexing in method chains point at the whole chain. The brackets span is still stored in AST/HIR (already present in 1.99.1) but is ignored here.
