# Adapted injection for For OutsideLoop we should not suggest add 'block label in if block, or we wiil get another err: block label not supported here.

Fix: https://github.com/rust-lang/rust/commit/8fde7e3b64109f5ebfadef4a015e2cb055bed08c

The pass moved to compiler/rustc_hir_typeck/src/loops.rs in 1.99.1 (diff against upstream's rustc_passes/src/loops.rs).

Changes (all in `CheckLoopVisitor`):
1. `visit_expr`: removed the `hir::ExprKind::If(cond, then, else_opt)` arm (fix hunk `@@ -83,6 +118,45 @@ ... fn visit_expr`, which pushes `UnlabeledIfBlock(b.span.shrink_to_lo())` for `if`/`else` blocks). Without it, if-blocks are treated as `UnlabeledBlock`, so a `break` in them gets the "add 'block label" suggestion that yields "block label not supported here".
2. `require_break_cx`: removed the `UnlabeledIfBlock(_) if Break => recurse(cx_pos - 1)` arm and `UnlabeledIfBlock` from the fallthrough pattern (fix hunk `@@ -239,17 +334,32 @@`).
3. Removed the `UnlabeledIfBlock(Span)` enum variant (fix hunk `@@ -25,22 +27,55 @@`, `+    UnlabeledIfBlock(Span),`), to avoid a dead-code warning.
