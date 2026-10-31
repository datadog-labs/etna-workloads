# Rationale

## Parser/lexer/lexer.c (tok_get_fstring_mode)
Reverses the single hunk of the fix: removes the `if (current_tok->quote_size == 1) { return syntaxerror("...newlines are not allowed in format specifiers for single quoted ...") }` block
in the `in_format_spec && c == '\n'` branch (in v3.15.2 it uses `quote_size` and a `%c-string` message rather than `f_string_quote_size`; same logic).
Without it, a newline in a format spec of a single-quoted f-string ends the spec and returns to regular mode, as before the fix.

## Oracle failures
`test.test_tokenize.CTokenizeTest.test_invalid_syntax` (case `f'__{\n x:d\n}__'`): TokenError not raised, since the tokenizer accepts the newline.
