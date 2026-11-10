# Adapted injection for Properly handle emojis as literal prefix in macros

Fix: https://github.com/rust-lang/rust/commit/19821ad23474a3d056feac94f11569841764eb87

# Rationale
File: compiler/rustc_lexer/src/lib.rs, fn `invalid_ident` (1.99 location of the logic).
Re-expresses fix hunk `@@ -528,7 +532,7 @@ impl Cursor<'_>` (`'#' | '"' | '\'' => InvalidPrefix,` replacing `UnknownPrefix`).
In 1.99.1 there is no InvalidPrefix kind; the fix's effect is that an emoji identifier followed by `#`/`"`/`'` lexes as a
distinct token that is always reported. Buggy behaviour restored: such an identifier lexes as `UnknownPrefix`, which the parser
only reports in edition 2021+, and is not registered in bad_unicode_identifiers, so in macro input `🐛"foo"` is accepted.
The other fix hunks (adding the InvalidPrefix variant, parser handling, rustdoc/r-a) are not needed since the variant is simply not used.
