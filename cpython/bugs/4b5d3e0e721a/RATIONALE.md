# Rationale

Bug: gh-120343, wrong column offsets for tokens following a multiline token on non-ASCII lines in tokenize.

In v3.15.2 the code lives in `Python/Python-tokenize.c` (`_get_current_line`, `_get_col_offsets`), refactored out of `tokenizeriter_next`. Two hunks were reverted:

1. `_get_current_line`: reverses the fix's `it->byte_col_offset_diff = 0;` hunk, restoring the old guard `if (it->tok->lineno != it->last_end_lineno)`. The diff is no longer reset when a new line starts after a multiline token.
2. `_get_col_offsets`: reverses the fix's `line_changed` branch. `col_offset` is again always `byte_offset - it->byte_col_offset_diff`, with no recomputation from the decoded line when the line changed. (`line_changed` is still set but is now unused for this.)

Failing oracle cases (2 failures in test_tokenize): `GenerateTokensTest.test_multiline_non_ascii_fstring_with_expr`, and its counterpart in the C tokenizer test class. The FSTRING_MIDDLE after `{test_arg1}` starts at (2, 35) instead of (2, 32).
