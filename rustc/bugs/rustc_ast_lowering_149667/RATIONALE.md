# Adapted injection for Fix ICE by rejecting const blocks in patterns during AST lowering

Fix: https://github.com/rust-lang/rust/commit/a9442b4a2ab42d9456eef32990791297942fa780

# Rationale
Most of the fix (HIR PatExprKind::ConstBlock removal, parser changes) is already in or structurally different in 1.99.1. Only the diagnostic help survives as a hunk to re-express.

## compiler/rustc_ast_lowering/src/pat.rs, `lower_expr_within_pat`
Fix hunk `@@ -419,10 +418,12 @@` added `let is_const_block = matches!(expr.kind, ExprKind::ConstBlock(_));` and `const_block_in_pattern_help: is_const_block`.
Re-injected: removed `is_const_block` and pass `const_block_in_pattern_help: false`, so a const block reaching pattern lowering (e.g. via `vec![const {..}]`) gets the generic error without the const-block help.
