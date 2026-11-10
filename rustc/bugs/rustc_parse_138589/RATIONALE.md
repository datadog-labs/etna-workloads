# Adapted injection for If a label is placed on the block of a loop instead of the header, suggest moving it to the header.

Fix: https://github.com/rust-lang/rust/commit/f478853f425fc0207add653b48c49c937acaa94e

# Rationale
File: compiler/rustc_parse/src/parser/expr.rs, functions `parse_expr_for`, `parse_expr_while`, `parse_expr_loop`.
Each call `self.parse_inner_attrs_and_block(opt_label.is_none().then_some(lo))` is changed back to `parse_inner_attrs_and_block(None)`.
This re-expresses the fix hunks `@@ -2851,7 +2851,11 @@` (for), `@@ -2894,11 +2898,17 @@` (while), `@@ -2912,7 +2922,11 @@` (loop), which replaced `parse_inner_attrs_and_block()` with a version passing `opt_label.is_none().then_some(lo)` as loop_header.
Without the loop header, a misplaced block label on a loop body only gets the tool-only "remove this block label" suggestion, not "move this label before the loop".
(The signature/diagnostics hunks already exist in 1.99.1 and are left in place; only the caller hunks are reverted.)
