# Adapted injection for Store raw ident span for raw lifetime

Fix: https://github.com/rust-lang/rust/commit/5de89bb011fdaaf9d300cf63f97a3cf4c86d367a

Hunk: compiler/rustc_parse/src/lexer/mod.rs, StringReader::next_token, RawLifetime arm.
Removed `self.psess.raw_identifier_spans.push(span);` (with its comment "Make sure we mark this as a raw identifier.") before `token::Lifetime(sym, IdentIsRaw::Yes)`.
Re-expresses fix hunk `@@ -299,6 +299,9 @@` which added `self.psess.raw_identifier_spans.push(self.mk_sp(start, self.pos));`. Without it, `'r#gen` is not recorded as a raw ident, so keyword_idents_2024 lint fires wrongly.
