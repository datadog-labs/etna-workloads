# Adapted injection for Fix bad suggestion when wrong parentheses around a dyn trait

Fix: https://github.com/rust-lang/rust/commit/ddcd7cac41b05995426b97f0f0bbca0866a1dd96

Fix hunks re-expressed (reverted) in 1.99.1 (messages moved inline into diagnostics.rs):
- compiler/rustc_parse/src/parser/ty.rs, parse_generic_ty_bound: fix hunk `@@ -873,18 +875,18 @@` changed
  `if self.token.is_like_plus()` to `... && leading_token.is_keyword(kw::Dyn)` and built the suggestion from
  `leading_token.span`. Restored old condition (no dyn check) and old spans `wrong_span: lo, new_span: self.prev_token.span`
  (old `l: lo, r: self.prev_token.span`).
- compiler/rustc_parse/src/diagnostics.rs, IncorrectParensTraitBoundsSugg: fix changed parts to `code = ""`/`code = "("`
  (`wrong_span`, `new_span`); restored both parts to `code = ""` (removes the parentheses instead of moving them).
