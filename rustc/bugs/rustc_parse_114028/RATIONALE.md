# Adapted injection for Gracefully handle missing ternary operator

Fix: https://github.com/rust-lang/rust/commit/16481807f5b106a6dcc627075fbdcd14add9495d

Bug: before the fix, rustc had no ternary-operator recovery. In 1.99.1 the logic lives in parser/diagnostics.rs and parser/stmt.rs (not messages.ftl/errors.rs hunks, which only define the diagnostic and are left in place).

1. compiler/rustc_parse/src/parser/diagnostics.rs, `expected_one_of_not_found`: removed the `if self.prev_token == token::Question && let Err(e) = self.maybe_recover_from_ternary_operator(None)` block in the "expected `;`" special case. Re-expresses fix hunk `@@ -500,6 +500,13 @@` (`if self.prev_token.kind == token::Question { ... maybe_recover_from_ternary_operator() ...}`).
2. compiler/rustc_parse/src/parser/stmt.rs, `error_on_incorrect_ternary / expect_semi path` (StmtKind::Expr without semicolon): removed the call to `maybe_recover_from_ternary_operator(Some(expr.span))` before `expect_one_of`. This is the later-evolved second call site of the same recovery introduced by the fix's `maybe_recover_from_ternary_operator` hunk (`@@ -1330,6 +1337,41 @@`).
