# Rationale

Hunk changed: `Python/Python-tokenize.c`, `tokenizeriter_next`. I removed the
`else if (type == NL)` branch inside the `tok_extra_tokens` block. The fix
added that branch. It replaces the NL token string with "" when
`tok->implicit_newline` is set. In v3.15.2 the branch uses
`Py_GetConstant(Py_CONSTANT_EMPTY_STR)` instead of `PyUnicode_FromString("")`.
The `str == NULL` check that the fix also added is left in place. It is harmless.

Without the branch, a file ending in a comment or whitespace with no trailing
newline gets an NL token whose string is a spurious "\n".

Oracle cases that fail (2 failures in test_tokenize): the fix's new tests
`test_comment_at_the_end_of_the_source_without_newline` and
`test_newline_and_space_at_the_end_of_the_source_without_newline`. Both get NL
string '\n' where '' is expected.
