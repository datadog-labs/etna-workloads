# Adapted injection for Fix inline_const with interpolated block

Fix: https://github.com/rust-lang/rust/commit/719797949ab1122d92a608b3f11f3321166b02eb

# Hunk: compiler/rustc_parse/src/parser/mod.rs, `parse_constness_`
Fix hunk `@@ -1210,7 +1210,8 @@ fn parse_constness_` replaced `look_ahead(1, |t| t != &OpenDelim(Brace))` with
`!look_ahead(1, |t| *t == OpenDelim(Brace) || t.is_whole_block())`.
In 1.99.1 the equivalent was `!look_ahead(1, |t| *t == token::OpenBrace || t.is_metavar_block())`; I restored the old
form `look_ahead(1, |t| t != &token::OpenBrace)`, so `const $block` (interpolated block) is parsed as a const item again.
