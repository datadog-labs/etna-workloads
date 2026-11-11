# Adapted injection for Catch stray { in let-chains

Fix: https://github.com/rust-lang/rust/commit/00942381575bc6c081835dbb38f68ce9603c032f

# Rationale
File: compiler/rustc_parse/src/lexer/tokentrees.rs, fn parse_token_tree_open_delim.
Removed the block that, on a correctly matched `{ ... }` whose first token is `&&`/`||`, pushes the span to `diag_info.if_let_chain_hint_spans` (which the lexer diagnostics turn into the "you might have meant to continue an if-let chain here" label).
This re-expresses the fix hunk `@@ -121,9 +122,40 @@ impl<'a> TokenTreesReader<'a>` (the `in_cond` / "found a `{` in the middle of a let-chain" detection of a stray `{` before `&& let`). The fix's code was rewritten upstream into this hint mechanism; without it, as before the fix, stray `{` in let-chains gets no hint.
