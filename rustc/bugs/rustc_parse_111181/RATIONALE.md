# Adapted injection for fix(parse): return unpected when current token is EOF

Fix: https://github.com/rust-lang/rust/commit/272dc5a6d5967c0816564894b4fd86835a860d97

# Rationale
File compiler/rustc_parse/src/parser/mod.rs, fn `Parser::expect_one_of`.
Re-expresses the fix hunk `@@ -536,7 +536,9 @@ impl<'a> Parser<'a>` which changed
`else if self.last_unexpected_token_span == Some(self.token.span)` to
`else if self.token.kind != token::Eof && self.last_unexpected_token_span == ...`.
I removed the `self.token != token::Eof &&` guard, so at EOF a repeated unexpected-token span raises FatalError instead of emitting the diagnostic.
