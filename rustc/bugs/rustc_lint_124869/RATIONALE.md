# Adapted injection for Make sure we don't deny macro vars w keyword names

Fix: https://github.com/rust-lang/rust/commit/1d9d6715aeb089209938ae5c8c487c1c65c85a53

# Rationale
compiler/rustc_lint/src/builtin.rs, `KeywordIdents::check_tokens`: removed the `prev_dollar` tracking
(and the now-unused `use ast::token::TokenKind;`), so idents after `$` (e.g. `$async`, `$gen`) are linted again.
Re-expresses fix hunk `@@ -1869,16 +1870,24 @@ struct UnderMacro(bool);` (added `prev_dollar`, `if !prev_dollar { check_ident_token }`,
`else if token.kind == TokenKind::Dollar { prev_dollar = true; continue; }`) and hunk 1 (the TokenKind import).
