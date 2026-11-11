# Adapted injection for validate link name parameter

Fix: https://github.com/rust-lang/rust/commit/c08b9abf6f0bcd7e56ae77909ffb2e3b2932229a

Only compiler/rustc_attr_parsing/src/attributes/link_attrs.rs changed (1.99.1 already has NullOnLinkName and no RawDylibNoNul, so only the validation hunks were reversed).
1. `LinkNameParser::convert`: removed the `contains('\0')` -> NullOnLinkName and `name.is_empty()` -> EmptyLinkName checks. Re-expresses hunk `@@ -46,6 +46,19 @@ impl<S: Stage> SingleAttributeParser<S> for LinkNameParser` (the added null/empty validation of `#[link_name]`).
2. `LinkParser::parse_link_name`: removed the `link_name.as_str().contains('\0')` -> NullOnLinkName check. Re-expresses hunk `@@ -270,9 +277,13 @@ impl LinkParser` (added NUL check for `#[link(name)]`).
