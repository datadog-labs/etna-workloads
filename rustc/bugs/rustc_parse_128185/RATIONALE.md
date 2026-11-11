# Adapted injection for Fix a span error when parsing a wrong param of function.

Fix: https://github.com/rust-lang/rust/commit/4ac60601d32d96688494c4bb404a04205501a02b

# Hunk: compiler/rustc_parse/src/parser/function.rs, `parse_fn_params` (the `parse_paren_comma_seq` closure)
The fix hunk (`@@ -2773,7 +2773,14 @@ impl<'a> Parser<'a>` in item.rs; code moved to function.rs in 1.99.1) replaced
`let lo = p.prev_token.span;` with a check that uses `prev_token.span.shrink_to_hi()` when prev token is `(`.
I reverted to `let lo = p.prev_token.span;`, so the placeholder param span includes `(`.
