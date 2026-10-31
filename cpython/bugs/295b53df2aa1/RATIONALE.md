# Rationale

Changed `_refold_parse_tree` in `Lib/email/_header_value_parser.py`: the
specials check now tests only `part.token_type == 'ptext'` instead of
`part.token_type == 'ptext' or part.contains_token_type('vtext')`.

This reverses the fix hunk `if part.token_type in ('ptext', 'vtext')` (v3.15.2
spells it as `contains_token_type('vtext')`, so the hunk could not be reversed
literally). Without it, a parsed encoded-word (whose terminals are 'vtext' in
structured headers) containing specials such as a comma is no longer kept
encoded when refolded, so it is emitted decoded and unquoted.

Oracle: 2 failures in test__header_value_parser, including
TestFolding.test_address_list_with_specials_in_encoded_word (the comma case
is left unencoded).
