# Adapted injection for Fix bug in `Parser::look_ahead`.

Fix: https://github.com/rust-lang/rust/commit/46b4c5adc5698c3e9543e17a1ed0f8073bafd1d3

# Rationale
File compiler/rustc_parse/src/parser/mod.rs, `Parser::look_ahead`, the `dist == 1` fast path.
Re-expresses fix hunk `@@ -1166,10 +1166,12 @@ impl<'a> Parser<'a>`: the fix added `if delim != Delimiter::Invisible { return looker(...) }`
(falling through to slow path for invisible delimiters). In 1.99.1 the guard is `if !delim.skip()`;
I removed it so the open-delimiter token is always returned, even for invisible delimiters.
