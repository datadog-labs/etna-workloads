# Rationale

Fix hunk reversed: `ListSeparator.as_ew_allowed = False` in
`Lib/email/_header_value_parser.py`. I removed that line, so the shared
`ListSeparator` terminal falls back to the class default `as_ew_allowed = True`.

The fix's other hunk made `get_address_list` append the shared `ListSeparator`
instead of a fresh `ValueTerminal(',', 'list-separator')`. In v3.15.2 that
change is already in place, and the shared terminal is also used elsewhere.
Reverting only the `as_ew_allowed` line restores the original defect: a comma
pushed onto a new line after a fold can be RFC 2047-encoded.

Oracle case that fails: `TestFolding.test_address_list_with_list_separator_after_fold`.
The `,` separator is encoded as an encoded word instead of being left as a literal comma.
