# Adapted injection for Do not recover from `Trait()` if generic list is unterminated

Fix: https://github.com/rust-lang/rust/commit/d194795f142639a7155ce82422f47fc56c53ed4b

# Rationale
File: compiler/rustc_parse/src/parser/ty.rs, function recovering `Trait<'a>(..)` into `for<'a> Trait(..)` (parse_remaining_fn_like recovery).
Removed the block
`if let Some(snapshot) = snapshot && ![token::Comma, token::Gt, token::Plus].contains(&self.token.kind) { self.restore_snapshot(snapshot); return Ok(()); }`
which re-expresses the last ty.rs hunk of fix.diff (`@@ -1503,6 +1533,17 @@`, "We would expect another bound or the end of type params by now"). Without it, `fn foo<T: Trait<'static>() {}` is wrongly recovered as Fn-like syntax.
The other hunks (parsing_generics flag, snapshot on errors) remain in 1.99.1 already and were left alone.
