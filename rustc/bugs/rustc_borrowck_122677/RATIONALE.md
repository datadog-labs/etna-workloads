# Adapted injection for Fix incorrect mutable suggestion information for binding in ref pattern.

Fix: https://github.com/rust-lang/rust/commit/19f72dfe04d030aba3885333156590d0b9191851

All changes are in compiler/rustc_borrowck/src/diagnostics/mutability_errors.rs.

1. `suggest_ampmut`-area ref-pattern suggestion (the `let &b = a;` -> `&(mut b)` block):
   removed the `| hir::Node::Param(Param { pat: Pat { kind: PatKind::Ref(..) }, .. })` alternative.
   Re-expresses hunk `@@ -725,25 +725,26 @@` which added the `hir::Node::Param(Param {...})` arm.
2. `BindingFinder`: removed `fn visit_param`, which returned `ControlFlow::Break(param.hir_id)` for
   Ref-pattern params. Re-expresses hunk `@@ -1310,6 +1311,16 @@` (`+ fn visit_param(...)`).
Result: for `fn foo(&x: &i32)` the `&(mut x)` suggestion is lost and the generic (wrong) suggestion is emitted.
The `use hir::{ExprKind, Param}` import is left in place (now an unused warning).
