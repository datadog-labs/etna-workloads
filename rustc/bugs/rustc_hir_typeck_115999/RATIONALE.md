# Adapted injection for Capture scrutinee of if let guards correctly

Fix: https://github.com/rust-lang/rust/commit/d4ffb3b08aa11e3b012e7efc31b28b78e01ed4bc

# Hunk: compiler/rustc_hir_typeck/src/expr_use_visitor.rs, `walk_arm`
Fix hunk `@@ -664,10 +664,12 @@ impl ExprUseVisitor`: replaced `Guard::IfLet(l) => self.consume_expr(l.init)` with
`self.walk_local(l.init, l.pat, None, |t| t.borrow_expr(l.init, ty::ImmBorrow))`.
In 1.99.1 guards are plain exprs (`ExprKind::Let`), so the borrow comes from the `ExprKind::Let` arm of walk_expr.
Re-injection: in `walk_arm`, if the guard is `ExprKind::Let`, `consume_expr(l.init)` (capture by value) instead of consuming the whole guard expr.
