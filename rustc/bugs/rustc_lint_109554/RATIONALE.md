# Adapted injection for Suggest ..= when someone tries to create an overflowing range

Fix: https://github.com/rust-lang/rust/commit/8e56c2c5f1e8417ae7dcaf1fad1d72dd1ca964f5

compiler/rustc_lint/src/types/literal.rs, lint_overflowing_range_endpoint: removed the "look past casts" block (parent Cast expr -> use cast expr's hir_id/span), so `0..256 as u8` is no longer recognised as an overflowing range endpoint and gets no `..=` suggestion.
Re-expresses fix hunk `@@ -136,6 +136,13 @@ fn lint_overflowing_range_endpoint` (added `let (expr, cast_ty) = if let Node::Expr(par_expr) ... ExprKind::Cast`), and the cast-aware suffix hunks, which in 1.99.1 are folded into the same span logic.
