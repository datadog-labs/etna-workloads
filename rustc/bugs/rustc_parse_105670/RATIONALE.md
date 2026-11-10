# Adapted injection for Fix condition for "missing `struct`" diagnostic on tuple structs

Fix: https://github.com/rust-lang/rust/commit/0757d5f83f4bc4faca896c85932cf1e4a0cd6031

compiler/rustc_parse/src/parser/item.rs, missing-keyword-for-item diagnostic (recover_missing_kw_for_item area):
`else if is_pub && self.check(exp!(Semi))` changed back to `exp!(Colon)`.
Re-expresses fix hunk `@@ -412,7 +412,7 @@`: `-} else if self.check(&token::Colon) {` / `+} else if self.check(&token::Semi) {` (the "struct" branch). Buggy parent matches `pub Foo(...):` instead of `;`.
