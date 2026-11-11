# Adapted injection for Fix parsing of erroneously placed semicolons

Fix: https://github.com/rust-lang/rust/commit/972633f53034d7d8d60f4c11b680b3f8f2aff337

Hunk: compiler/rustc_parse/src/parser/item.rs, `Parser::parse_mod`.
Re-expresses fix hunk `@@ -58,9 +58,15 @@ impl<'a> Parser<'a>`: restores the pre-fix loop
`while let Some(item) = self.parse_item(..)? { self.maybe_consume_incorrect_semicolon(Some(&item)); items.push(item); }`
in place of the `loop { while self.maybe_consume_incorrect_semicolon(items.last()..) {} ... }`, so a leading stray `;` is no longer handled before the first item (issue 124935).
