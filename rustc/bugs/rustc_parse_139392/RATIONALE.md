# Adapted injection for Detect and provide suggestion for `&raw EXPR`

Fix: https://github.com/rust-lang/rust/commit/6dfbe7c986d55a5a48f625d37d4576092e5638eb

# Rationale
File compiler/rustc_parse/src/parser/expr.rs, fn parse_expr_addr_of: removed the block
"Add expected tokens if we parsed `&raw` as an expression" that inserts TokenType::KwMut and KwConst
into expected_token_types when `&raw` was parsed as a path expr. Re-expresses the fix hunk
`@@ -829,6 +829,18 @@ impl<'a> Parser<'a>` in expr.rs. Without it the "`&raw` must be followed by const or mut"
suggestion and the expected-token list are lost. Other fix hunks left in place (1.99.1 already has them).
