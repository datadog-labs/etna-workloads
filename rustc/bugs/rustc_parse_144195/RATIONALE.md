# Adapted injection for Added checks for attribute in type case

Fix: https://github.com/rust-lang/rust/commit/d09cf616f74e068cfb092e91472fb0ae371529ad

# Rationale
compiler/rustc_parse/src/parser/ty.rs, `parse_ty_common`: removed the block
`if self.token == token::Pound && self.look_ahead(1, |t| *t == token::OpenBracket) { ... AttributeOnType / AttributeOnEmptyType ... return Ok(self.mk_ty(full_span, TyKind::Err(guar))) }`
and the now-unused imports. Re-expresses fix hunk `@@ -253,7 +253,27 @@ impl<'a> Parser<'a>` in ty.rs (the added attribute check in type parsing). Without it, `#[attr] T` in type position is no longer given the dedicated errors.
