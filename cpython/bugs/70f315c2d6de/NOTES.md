`repro.py` tokenizes the source `"); x"` with `tokenize.generate_tokens` and prints each token.
Clean: prints the tokens `)`, `;`, `x`, NEWLINE, ENDMARKER (exit 0).
Buggy: the C tokenizer raises `tokenize.TokenError: ("unmatched ')'", (1, 1))` (exit 1), because the unmatched-paren syntax error is no longer disabled in tokenize's extra-tokens mode.
