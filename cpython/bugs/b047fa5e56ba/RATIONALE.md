# Rationale

All changes are in `tree/Parser/lexer/lexer.c` (the tokenizer moved from Parser/tokenizer.c). Each reverses one hunk of fix.patch:

1. `verify_end_of_number`: removed the early `return 1` when `tok->tok_extra_tokens` is set. In tokenize mode, `2sin(x)` once again goes through the strict end-of-number check and raises instead of yielding NUMBER `2` and NAME `sin`.
2. `verify_identifier`: removed the early `return 1` under `tok_extra_tokens`, so identifiers are validated again in tokenize mode.
3. Old-style octal check: `else if (nonzero && !tok->tok_extra_tokens)` became `else if (nonzero)`. Zero-prefixed literals such as `01234` raise a SyntaxError in the tokenize module again.

## Failing oracle cases
- `InvalidPythonTests.test_number_followed_by_name`: TokenError for `2sin(x)`.
- `InvalidPythonTests.test_number_starting_with_zero`: TokenError "leading zeros in decimal integer literals are not permitted" for `01234`.
