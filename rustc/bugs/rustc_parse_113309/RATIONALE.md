# Adapted injection for Detect extra space in keyword for better hint

Fix: https://github.com/rust-lang/rust/commit/799d2917e7bb36c95224436a39cd2d468f93f45d

compiler/rustc_parse/src/parser/diagnostics.rs, in Parser::expected_one_of_not_found (the diagnostic-hint code).
Removed the block `if let TokenKind::Ident(prev,_) = &self.prev_token.kind && let TokenKind::Ident(cur,_) = &self.token.kind { ... "consider removing the space to spell keyword `{concat}`" ... }`.
This re-expresses the fix hunk `@@ -605,6 +605,22 @@ impl<'a> Parser<'a>`, which added that block. Without it, the parent behaviour returns: no hint for `le t`.
