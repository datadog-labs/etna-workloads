Tokenizes `2sin(x)` and `01234` with `tokenize.generate_tokens`.
Clean: NUMBER/NAME tokens are produced (`2`,`sin`,...) and `01234` is a single NUMBER.
Buggy: the C tokenizer in extra-tokens mode raises errors (invalid decimal literal / leading zeros) instead.
