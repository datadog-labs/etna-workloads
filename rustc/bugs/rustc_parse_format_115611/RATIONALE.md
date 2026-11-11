# Adapted injection for add diagnostic for raw identifiers in format string

Fix: https://github.com/rust-lang/rust/commit/d990eee0c8ae2ce465351b00abbdb8bfdd1caf4b

# Rationale
File compiler/rustc_parse_format/src/lib.rs, `Parser::position`: removed the "Recover from `r#ident` in format strings" block (the `if word == "r" && peek == '#' ...` that inserts the "raw identifiers are not supported" ParseError with `Suggestion::RemoveRawIdent`). This re-expresses fix hunk `@@ -573,7 +583,37 @@` (`Some(&(lo, c)) if is_id_start(c) => { let word = self.word(); // Recover from r#ident ...`), restoring the parent's plain `Some(ArgumentNamed(self.word()))`. The Suggestion enum / diagnostics plumbing was left in place (now unused paths), only the behavioural hunk is reverted.
