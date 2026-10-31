# Rationale

In v3.15.2 the fix's `leading_whitespace` machinery was rewritten as a
`last_word_is_ew` parameter in `_fold_as_ew` (Lib/email/_header_value_parser.py).
The `elif last_word_is_ew:` branch moves whitespace sitting between two
encoded words into the second encoded word. This is the same defect the fix
addressed (fix hunks `leading_whitespace` / `_fold_as_ew` `if` -> `elif`,
and the encode of `leading_whitespace` on continuation lines).

Change: removed that branch, so `_fold_as_ew` goes straight to
`elif to_encode[0] in WSP`, the pre-fix behaviour. Whitespace between two
encoded words is left unencoded and is dropped by a compliant decoder.
The `last_word_is_ew` parameter is still passed but no longer used.

Oracle failures: test_generator (a test in
TestBytesGenerator/TestGenerator; the "spaces between encoded words" cases)
and test_headerregistry TestFolding.test_address_display_names, which
produces `=?utf-8?q?adipiscing...` instead of `=?utf-8?q?_adipiscing...`
(missing space).
