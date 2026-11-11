# Adapted injection for fix #108495, postfix decrement and prefix decrement has no warning

Fix: https://github.com/rust-lang/rust/commit/46ea12a499aecd655a5c954431466db0a66e8ec9

# Rationale
- compiler/rustc_parse/src/parser/expr.rs, `parse_expr_assoc_rest_with`: removed the block that detects `--` after an lhs (prev_token Minus, token Minus, adjacent) and calls `recover_from_postfix_decrement`. Re-expresses fix hunk `@@ -281,6 +281,16 @@` (added `if self.prev_token == token::BinOp(token::Minus) && ... recover_from_postfix_decrement`).
- compiler/rustc_parse/src/parser/diagnostics.rs: `#[allow(dead_code)]` on `recover_from_postfix_decrement`, matching fix hunks `-1331/-1342/-1356` that toggled dead_code allows (needed so it builds warning-free).
Prefix-decrement recovery in 1.99.1 lives elsewhere and was left as is; the postfix removal alone fails the oracle test.
