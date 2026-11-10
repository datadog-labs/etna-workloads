# Adapted injection for check is_ident before parse_ident

Fix: https://github.com/rust-lang/rust/commit/a01f49e7f32b39b77f6a5804c1ed12aadaa89ec5

compiler/rustc_parse/src/parser/item.rs, `recover_missing_kw_before_item` (ident computation): removed the `self.token.is_ident() &&` guard before the `(!is_const || look_ahead(1, OpenParen))` condition, so `parse_ident_common(true).unwrap()` can run on a non-ident token (`const!(...)`) and ICE.
Re-expresses fix hunk `@@ -387,8 +387,8 @@` : `let ident = if self.token.is_ident() && (...)`.
