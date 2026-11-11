# Adapted injection for Detect ruby-style closure in parser

Fix: https://github.com/rust-lang/rust/commit/6b2c6c7fd3860cc9e6fde3077b889abbd6a30892

# Rationale
File: compiler/rustc_parse/src/parser/expr.rs, fn `parse_expr_let`.
Re-expresses fix hunk `@@ -2459,10 +2465,16 @@ ... fn parse_expr_let`: the fix added
`if self.prev_token.kind == token::BinOp(token::Or) { return Err(err...) } else { Some(emit_err(err)) }`
so a `let` directly after a closure head `|x|` returns an Err for the closure recovery to handle.
Bug re-injected: always emit the error immediately (parent behaviour), so closure recovery
(`recover_closure_body`) never sees the `let` error and the ruby-style/missing-block suggestions are lost.
The other fix hunks (recover_closure_body, parse_expr_closure) remain in 1.99.1 untouched.
