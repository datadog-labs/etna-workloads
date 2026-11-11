# Adapted injection for Validate source snippet when format input is raw string

Fix: https://github.com/rust-lang/rust/commit/6b3d04e5f961d3cf9c208fd27a2652e5e26f4d2b

# Rationale
File compiler/rustc_parse_format/src/lib.rs, `Parser::new`: the raw-string branch (`if let Some(nr_hashes) = style`) is restored to the pre-fix behaviour. It trusts the snippet blindly: `(true, snippet.len() - nr_hashes - 1, vec![])`.
This re-expresses the fix hunk `@@ -307,24 +307,46 @@ impl<'input> Parser<'input>`, which added validation of the prefix (`r`, hashes, `"`), the suffix, and snippet_without_quotes == input. A proc macro that respans the literal can therefore make the snippet slice at a bad (multi-byte) offset and ICE (#114865).
The unrelated rename in the fix hunk (without_quotes) was not reverted, since it has no behavioural effect.
