# Adapted injection for Handle str literals written with `'` lexed as lifetime

Fix: https://github.com/rust-lang/rust/commit/982918f4935fd4677af06d42e0d0b298bfb1c243

# Rationale
File compiler/rustc_parse/src/lexer/mod.rs, fn cook_lexer_literal, `LiteralKind::Char { terminated }` arm.
Re-expresses fix hunk `@@ -395,10 +413,21 @@ ... rustc_lexer::LiteralKind::Char { terminated }`: the fix turned the plain
`struct_span_fatal(...).with_code(E0762).emit()` into building `err` and adding a
`multipart_suggestion(... use double quotes ...)` when `self.last_lifetime` is Some.
The bug restores the old plain emit, with no suggestion for `'hello world'` / `'1 + 1'`.
