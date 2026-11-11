# Adapted injection for Handle interpolated literal errors

Fix: https://github.com/rust-lang/rust/commit/9ef580fa6f2b5019b35e6a9cf979f6f13d21de00

# Hunk: compiler/rustc_parse/src/parser/expr.rs, `Parser::parse_opt_meta_item_lit`
Re-expresses fix hunk `@@ -2023,17 +2023,14 @@ impl<'a> Parser<'a>` (error path of literal parsing: `let span = token.uninterpolated_span();` replacing `token.span`).
In 1.99.1 the code was restructured; the fixed behaviour is `report_lit_error(..., uninterpolated_span)` and `MetaItemLit::from_token_lit(token_lit, uninterpolated_span)`.
Reinjected bug: both use `self.token.span` (the interpolated/invisible-delimited span) instead of the uninterpolated one, so literal errors from `$x:literal` in macros point at the wrong span.
