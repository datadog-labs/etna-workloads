# Adapted injection for Improve error message when closing bracket interpreted as formatting fill character

Fix: https://github.com/rust-lang/rust/commit/a872762151760d65bddf6b3ebad19bc3ea7ec31d

# Rationale
compiler/rustc_parse_format/src/lib.rs, `Parser::consume_closing_brace` (1.99.1 form of fix's `consume_closing_brace` hunk, `@@ -450,69 +452,51 @@`):
the fix added `let (note, secondary_label) = if arg.format.fill == Some('}') { "the character `'}'` is interpreted as a fill character..." , fill_span } else { escape-`{{` note }`.
Re-injected the old behaviour: always emit the "if you intended to print `{`..." note and last-open-brace secondary label, ignoring the `}` fill case.
