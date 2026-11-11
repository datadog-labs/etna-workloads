# Adapted injection for Properly analyze captures from unsafe binders

Fix: https://github.com/rust-lang/rust/commit/04ddafc53ce0e045bae86ad0b20f5be540ca0e84

# Re-injected bug
File: compiler/rustc_hir_typeck/src/expr_use_visitor.rs, fn cat_expr (plus removal of now-unused `use rustc_ast::UnsafeBinderCastKind`).
Re-expresses the fix hunk `@@ -1393,10 +1394,18 @@ ... cat_expr`: restores
`hir::ExprKind::UnsafeBinderCast(_, e, _) => self.cat_expr(e),` (unsafe binder casts treated as transparent for place-ness)
instead of `UnsafeBinderCast(Unwrap, ..)` producing a `ProjectionKind::UnwrapUnsafeBinder` projection, and drops the
`| UnsafeBinderCast(Wrap, ..)` rvalue arm added in hunk `@@ -1427,6 +1436,7 @@`. Other hunks (new enum variant and match arms) are left in place; they're inert without the producer.
