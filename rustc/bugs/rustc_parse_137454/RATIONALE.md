# Adapted injection for not lint break with label and unsafe block

Fix: https://github.com/rust-lang/rust/commit/3fe0b3d4d04dd86cbe22770217f3b42a8856d382

compiler/rustc_parse/src/parser/expr.rs, parse_expr_break: the `break_with_label_and_loop` lint condition
was restored to the pre-fix `matches!(expr.kind, While | ForLoop{label:None} | Loop | Block(_, None))`.
This drops the `BlockCheckMode::Default` check on `ExprKind::Block(block, None)`, so `break 'l unsafe { .. }` lints.
Re-expresses hunk `@@ -1859,13 +1859,15 @@` (`ExprKind::Block(block, None) => matches!(block.rules, BlockCheckMode::Default)`).
