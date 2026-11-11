# Adapted injection for Use opt functions to not ICE in fallback suggestion

Fix: https://github.com/rust-lang/rust/commit/82f8b8f0e3f44c7280f21364b54840f59890610a

All in compiler/rustc_hir_typeck/src/fallback.rs (AnnotateUnitFallbackVisitor), reverting the fix's three hunks:
- visit_infer (fix hunk `@@ -643,7 +643,7 @@ visit_ty`: `let Some(ty) = ...node_type_opt(hir_ty.hir_id)`): now `let ty = ...node_type(inf_id)` which ICEs when the node has no type.
- visit_expr (fix hunk `@@ -680,7 +680,8 @@`: `node_args_opt`): back to `node_args(expr.hir_id)`.
- visit_local (fix hunk `@@ -701,7 +702,7 @@`: `node_type_opt(local.hir_id)`): back to `node_type(local.hir_id)`.
