# Rationale

## Parser/action_helpers.c `_PyPegen_setup_full_format_spec`
The fix added a special case turning a format spec consisting of a single empty
string Constant into an empty JoinedStr (3.11 compatibility). In v3.15.2 this
is done by a generalised loop that drops all empty-string constants from `spec`.
I removed that whole filtering block, so `f'{x:}'` again yields a
JoinedStr containing one empty `Constant('')` (the pre-fix behaviour) via the
`n == 1 && Constant_kind` branch.

## Oracle
`test_fstring.TestCase.test_ast_fstring_empty_format_spec` fails:
`len(format_spec.values)` is 1 instead of 0.
