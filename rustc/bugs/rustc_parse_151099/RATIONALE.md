# Adapted injection for Recover parse gracefully from `<const N>`

Fix: https://github.com/rust-lang/rust/commit/92db7b2b5ab89a37a2d7bdd9c8a25fd8be31e303

# Rationale
File: compiler/rustc_parse/src/parser/generics.rs, fn `parse_const_param`.
Re-expresses the single fix hunk `@@ -109,7 +109,31 @@ impl<'a> Parser<'a>`: the fix replaced `self.expect(exp!(Colon))?;` with an `if let Err(mut err) = self.expect(exp!(Colon))` block that recovers on `,`/`>` with a `: /* Type */` suggestion and a `TyKind::Err` placeholder param. I restored the old line `self.expect(exp!(Colon))?;`, so `<const N>` is a hard parse error with no recovery (later errors are silenced).
