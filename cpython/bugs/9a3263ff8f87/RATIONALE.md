# Rationale

Lib/argparse.py, `HelpFormatter._expand_help`: the fix replaced the old
"wrap every param value in color codes, then `help_string % params`" with
`help_string % params` followed by a regex pass that colorizes only the
interpolated results. I restored the pre-fix code: every value in `params` is
wrapped in `interpolated_value ... reset` strings before interpolation, and
the result is returned (through `_apply_text_markup`, which v3.15.2 added
later). The regex `fmt_spec` and `colorize` helper are removed.

Effect: values become strings containing color codes, so numeric specifiers
(`%(default)x`, `%(default)05d`, `%(default)d`) raise TypeError/ValueError
("badly formed help string") when color is on.

Failing oracle case: `test.test_argparse.TestColorized.test_help_with_format_specifiers`
(ValueError: badly formed help string from `add_argument` with `%(default)x`).
