# Adapted injection for Suggest fix for ; within let-chains

Fix: https://github.com/rust-lang/rust/commit/5693a34db2f0e929995fe7aa03d307bafa9360aa

compiler/rustc_parse/src/parser/expr.rs, parse_expr_if (the `parse_block().map_err` closure for a missing `{`):
removed the branch `if self.prev_token == token::Semi && self.token == token::AndAnd && look_ahead(1) is `let``
that suggested removing the semicolon and noted the let-chain continuation. This re-expresses the fix hunk
`@@ -2441,10 +2441,26 @@` (which added that branch). The old behaviour (always the generic
"the `if` expression is missing a block" note) is restored; the other later-added suggestions remain.
