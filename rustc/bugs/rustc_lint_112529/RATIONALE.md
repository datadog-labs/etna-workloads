# Adapted injection for Extend `unused_must_use` to cover block exprs

Fix: https://github.com/rust-lang/rust/commit/72b3b58efc6ed4bab93ba98586b62750abbdda79

# Rationale
File compiler/rustc_lint/src/unused/must_use.rs (moved from unused.rs), `UnusedResults::check_stmt`.
Re-expresses fix hunk `@@ -93,7 +94,15 @@ ... check_stmt`: the fix added `let hir::StmtKind::Semi(mut expr)` and a
`while let hir::ExprKind::Block(blk, ..) = expr.kind && let hir::Block { expr: Some(e), .. } = blk { expr = e; expr_is_from_block = true; }` loop
that peels block tail expressions. Reverted: `expr` is immutable and `expr_is_from_block` is constant false, so
`{ must_use_fn() };` is no longer linted. The other hunks (threading the flag, suggestion variants) are left in place since they are inert with the flag false.
