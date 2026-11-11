# Adapted injection for Detect Python-like slicing and suggest how to fix

Fix: https://github.com/rust-lang/rust/commit/e65c060d78db59c5f21cb13f4ec322e407f0a642

# Rationale
compiler/rustc_parse/src/parser/stmt.rs, `parse_full_stmt` recovery loop in `parse_block_tail` (the `if self.token == token::Colon` block):
removed the `prev_token.is_integer_lit() && look_ahead(1, is_integer_lit)` branch that emits the
"you might have meant a range expression" `..` suggestion, leaving only the path-separator suggestion.
Re-expresses fix hunk `@@ -567,6 +567,22 @@ impl<'a> Parser<'a>` (added the `1:42` integer-literal check and `err.span_suggestion_verbose(... "..")`).
The `is_integer_lit` helper in token.rs (first hunk) is kept (now unused by the parser; harmless).
