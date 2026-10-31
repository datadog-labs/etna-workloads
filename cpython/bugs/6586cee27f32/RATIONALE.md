# Rationale

Hunk reversed: `Parser/string_parser.c` `warn_invalid_escape_sequence` — removed the early
`return 0` for `{`/`}` escapes in FSTRING_MIDDLE/FSTRING_END (and the TSTRING_* variants added since).
This is the fix's added check. Without it the parser warns a second time for `\{`/`\}`, after the
tokenizer already warned (the tokenizer's SyntaxWarning switch is already in place in v3.15.2 and
was left alone).

Failing oracle case: `test_fstring_backslash_before_double_bracket_warns_once`
(`eval(r"f'\{{'")` emits 2 warnings instead of 1: `AssertionError: 2 != 1`).
