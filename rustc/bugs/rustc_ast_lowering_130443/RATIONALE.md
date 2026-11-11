# Adapted injection for Fix ICE when passing DefId-creating args to legacy_const_generics.

Fix: https://github.com/rust-lang/rust/commit/b462c68aee956602408373975d3ca898e464030b

# Rationale
File: compiler/rustc_ast_lowering/src/expr.rs, fn `lower_legacy_const_generics`.
Re-expresses the fix hunk `@@ -410,7 +461,20 @@ impl<'hir> LoweringContext` which added
`let mut visitor = WillCreateDefIdsVisitor {}; let const_value = if let ControlFlow::Break(span) = visitor.visit_expr(&arg) { ... ExprKind::Err(invalid_expr_error(..)) } else { arg };`.
Buggy (parent) behaviour restored: the argument is used directly (`let const_value = arg;`) as the AnonConst value, so closures/const blocks/items inside get DefIds created at the wrong time -> ICE.
The `invalid_expr_error` closure (hunk `@@ -396,10 +423,34 @@`) is left in place but is now unused, so `#[allow(unused_variables, unused_mut)]` was added to keep the build warning-free.
