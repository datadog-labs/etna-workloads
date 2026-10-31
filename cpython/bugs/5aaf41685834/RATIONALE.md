# Rationale

Fix hunk reversed: the `_refold_parse_tree` hunk that, for a `bare-quoted-string`,
builds terminals for the opening/closing `"` and escapes each piece with
`make_quoted_pairs`. In v3.15.2 this logic lives in `_refold_with_ew`
(Lib/email/_header_value_parser.py), where it is followed by a call to
`_refold_without_ew` and `continue`. I removed that whole `bare-quoted-string`
block, so a too-long quoted string is folded via its bare subparts again
(no surrounding quotes, no escaping of `\` and `"`), as before the fix.
`make_quoted_pairs` and `quote_string` are left alone (the `quote_string`
refactor was behaviour-neutral).

Oracle: 6 cases in TestFolding fail, including
`test_address_list_with_specials_in_long_quoted_string` and
`test_address_list_with_list_separator_after_fold` (quotes dropped when folded).
