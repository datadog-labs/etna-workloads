# Rationale

Fix: gh-120343, `byte_col_offset_diff` must not be reset after a multiline token
(non-ASCII text on the end line of a multiline f-string/string shifted later columns).

In v3.15.2 `_get_current_line` already resets `byte_col_offset_diff = 0` on every line
change unconditionally (the pre-fix form, the `last_end_lineno` guard is gone; the field is
set but unused). The bug was masked, though, by the `if (line_changed)` branch in
`_get_col_offsets`, which recomputes the character column and `byte_col_offset_diff` from the
decoded line. I removed that branch, so `col_offset` is always `byte_offset - byte_col_offset_diff`,
as in the pre-fix code. The diff accumulated over a multiline token is then lost by the
reset, and tokens after it on its last line get wrong columns.

Only change: `Python/Python-tokenize.c`, `_get_col_offsets` (the `line_changed` branch removed).

Failing oracle cases: `{Generate,}TokenizeTest.test_multiline_non_ascii_fstring` and
`..._with_expr` (the `{`/following tokens on line 2 get columns too large, e.g. (2, 24) vs (2, 21)).
