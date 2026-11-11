# Adapted injection for On let binding type point to type parameter that introduced unmet bound

Fix: https://github.com/rust-lang/rust/commit/bac0e556f008f5853d13fd98b859348b5ba813a9

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/adjust_fulfillment_errors.rs, fn `adjust_fulfillment_error_for_expr_obligation`.
Removed the `hir::Node::Ty(hir::Ty { kind: TyKind::Path(qpath), .. })` match arm, so obligations whose HIR node is a type path (e.g. `<S as D>::P<String>` in a let binding) are no longer narrowed to the offending generic arg and the whole type is blamed again.
This re-expresses the fix hunk `@@ -127,68 +118,83 @@` which introduced `hir::Node::Ty(hir::Ty { kind: hir::TyKind::Path(qpath), .. }) => (None, Some(*qpath))` (before the fix, any non-Expr node hit `let hir::Node::Expr(expr) = ... else { return false; }`). In 1.99.1 the logic was restructured into a match, so deleting the Ty arm restores the old `false` fallthrough.
