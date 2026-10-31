# Rationale

## Parser/tokenizer/string_tokenizer.c, decode_str()
Reverses the fix hunk that added
`else if (!_PyTokenizer_ensure_utf8(str, tok, 1)) return _PyTokenizer_error_ret(tok);`
after the `tok->enc != NULL` branch. Without it, string/bytes source using the
default (UTF-8) encoding is no longer validated up front, so non-UTF-8 bytes in
comments/shebang lines (which the tokenizer skips) go undetected. This is the
pre-fix behaviour ("Detect decoding error in comments for UTF-8 encoding").
The other pieces of the fix (file tokenizer, error positions) are left intact in v3.15.2.

## Oracle failures
Five cases in test_source_encoding.BytesSourceEncodingTest fail because the
expected SyntaxError "Non-UTF-8 code starting with ... on line N" is not raised
and the script runs on to `RuntimeError`: test_non_utf8_second_line_error,
test_non_utf8_shebang_error, test_non_utf8_third_line_error,
test_utf8_bom_non_utf8_third_line_error, test_utf_8_non_utf8_third_line_error.
