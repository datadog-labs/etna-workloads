# Rationale

Fix gh-105042 made the C tokenizer tolerate unmatched/mismatched closing brackets when `tok->tok_extra_tokens` is set (the mode used by the Python `tokenize` module). I removed that tolerance in `Parser/lexer/lexer.c` (the `case ')' / ']' / '}'` branch of `tok_get_normal_mode`).

- Fix hunk "`if (!tok->tok_extra_tokens && !tok->level)`": restored the pre-fix `if (!tok->level)`, so an unmatched closing bracket always raises `unmatched ')'`, even in extra-tokens mode.
- Fix hunk that added `!tok->tok_extra_tokens &&` to the bracket-mismatch check: I removed the `if (tok->tok_extra_tokens) { /* Allow other mismatched brackets. */ }` branch that v3.15.2 uses for this. Mismatched brackets always raise "closing parenthesis ... does not match" again.
- The `Python-tokenize.c` hunk (`if (tok->level)` to `if (tok->level > 0)`) is not reversed. It is a no-op on v3.15.2.

## Oracle failures
`TokenizeTest.test_closing_parenthesis_from_different_line` and `GenerateTokensTest.test_closing_parenthesis_from_different_line` fail. Tokenizing `"); x"` raises `TokenError: ("unmatched ')'", (1, 1))`.
