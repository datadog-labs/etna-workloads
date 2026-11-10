# Adapted injection for Fix ICE in tokenstream with contracts from parser recovery

Fix: https://github.com/rust-lang/rust/commit/adcd0bf5c36ee49acf390f0d75125da4efda35ac

# Hunk: compiler/rustc_parse/src/parser/stmt.rs, error_block_no_opening_brace_msg
In the `Err(e)` arm of the `parse_stmt_without_recovery` match, the fix's hunk
`@@ -558,20 +558,19 @@ impl<'a> Parser<'a> {` replaced
`self.recover_stmt_(SemiColonMode::Break, BlockMode::Ignore); e.cancel();` with `e.delay_as_bug();`.
I restored the old lines. Recovery consumes tokens and the error is cancelled, which causes the tokenstream ICE with contracts.
(The `e` -> `err` renames in the fix are cosmetic and were not reverted.)
