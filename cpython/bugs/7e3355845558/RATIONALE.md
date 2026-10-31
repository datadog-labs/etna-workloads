# Rationale

Hunk reversed: `Grammar/python.gram` `raise_stmt` (fix hunk of gh-135422). The fix put the
plain `'raise' expression 'from' expression` alternative before `invalid_raise_stmt` and split
the optional `from` clause out. I restored the pre-fix form: `invalid_raise_stmt` first, then
`'raise' a=expression b=['from' z=expression { z }]`. `Parser/parser.c` was regenerated with pegen.

Effect: on the second (invalid-rules) pass, `raise X from None` hits `invalid_raise_stmt`
(`'raise' expression 'from'`) before the valid rule, so a valid raise-from statement raises
"did you forget an expression after 'from'?" and masks later real syntax errors.

Oracle: `test_syntax.test_raise_from_error_message` fails (plus one other test_syntax failure
in the same area): the error reported is the bogus 'from' message instead of "invalid syntax" at line 3.
