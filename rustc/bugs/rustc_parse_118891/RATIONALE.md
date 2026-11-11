# Adapted injection for Actually parse async gen blocks correctly

Fix: https://github.com/rust-lang/rust/commit/1d78ce681e4bf0c0259fc97e422298d68635dc4f

Both hunks in compiler/rustc_parse/src/parser/expr.rs (fix.diff hunks `@@ -1440,21 +1440,23 @@` and `@@ -3219,9 +3221,16 @@`) reversed by hand.

1. `parse_expr_bottom`: restored the old order. `async` is checked first (`async {` -> parse_gen_block, otherwise parse_expr_closure), so `async gen {}` is no longer routed to parse_gen_block. The `gen` check (2024 only) comes after and only looks at lookahead 0. This re-expresses the removed `} else if this.token.uninterpolated_span().at_least_rust_2024() && (this.is_gen_block(kw::Gen, 0) || (check_keyword(Async) && is_gen_block(Gen, 1)))` after the async branch.
2. `parse_gen_block`: restored the gate on `Gen` only (`gate(sym::gen_blocks, lo.to(self.token.span))`) and removed the `match kind` that also gated AsyncGen, so `async gen` blocks are not feature-gated.
