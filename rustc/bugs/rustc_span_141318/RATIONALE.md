# Adapted injection for Avoid creating an empty identifer in `Symbol::to_ident_string`.

Fix: https://github.com/rust-lang/rust/commit/1cc0e38fdc4d2ec8c9c130d7ffc9c30d100885a2

# Rationale
compiler/rustc_span/src/symbol.rs, `Symbol::to_ident_string`: removed the empty-symbol guard
(`if self == sym::empty { String::new() } else {...}`), restoring `Ident::with_dummy_span(self).to_string()`.
Re-expresses fix hunk `@@ -2592,7 +2592,8 @@ impl Symbol` (`if self == kw::Empty { String::new() } else {...}`).
