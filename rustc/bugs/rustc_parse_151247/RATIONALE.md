# Adapted injection for Try to recover from over-parsing in const item when a semicolon is missing

Fix: https://github.com/rust-lang/rust/commit/b4f15dcead2b53d889b15e77aee1f81cd52bdb84

# Rationale
File: compiler/rustc_parse/src/parser/item.rs, const item parsing function (end of the const-item parser).
Fix hunk `@@ -1634,6 +1637,9 @@ impl<'a> Parser<'a>` added
`if let Some(recovered_rhs) = self.try_recover_const_missing_semi(&rhs) { return Ok(...) }` before `self.expect_semi()?;`.
In 1.99.1 the call is `try_recover_const_missing_semi(&rhs, const_span)`; I removed that call, so over-parsed
`const C: u8 = 1\n + 2` is no longer recovered. Added `#[allow(dead_code)]` on the now-unused helper (the helper's own hunk is unchanged otherwise).
