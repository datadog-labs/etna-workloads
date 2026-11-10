# Adapted injection for Check for presence of field in typeck results before visiting it

Fix: https://github.com/rust-lang/rust/commit/4f773af1cc17621e7c52afba6be2db21b2f3aba5

All in compiler/rustc_passes/src/dead.rs.

1. `MarkSymbolVisitor::visit_expr`, `hir::ExprKind::Field` arm: removed the `opt_field_index(expr.hir_id).is_some()` guard and delayed bug; now unconditionally calls `self.handle_field_access(lhs, expr.hir_id)`. Reverses fix hunk `@@ -464,7 +464,11 @@ impl<'tcx> Visitor<'tcx> for MarkSymbolVisitor<'tcx>`.
2. `MarkSymbolVisitor::visit_nested_body`: removed the later-added `tainted_by_errors` early return. On 1.99.1 that check masks the bug (the body is skipped before reaching the Field arm), so without removing it hunk 1 alone gives no failure. Needed to restore the parent's behaviour in which tainted bodies were visited.
