# Rationale

Fix hunk reversed: the second `_refold_parse_tree` hunk, which added the check
before `_fold_as_ew` that resets `last_ew = None` when the previous encoded word
had charset `unknown-8bit` (or `utf-8` and the new one is not `us-ascii`) and
the charset changed. In v3.15.2 the same check is at the `part.as_ew_allowed`
branch (Lib/email/_header_value_parser.py); I removed it. The `last_charset`
bookkeeping stays (it is now unused), as with the original code where the
variable only existed for the check.

Result: encoded words with different charsets get combined again, so
unknown-8bit and non-unknown-8bit text are re-encoded together.

Oracle cases failing: test_unicode_after_unknown_not_combined (UnicodeEncodeError),
test_unknown_after_unicode_not_combined (wrong output: combined as
`=?unknown-8bit?b?wqSk?=`), and test_ascii_after_unknown_not_combined (error).
