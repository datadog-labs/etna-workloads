# Rationale

Fix hunk: wrapped the parsing loop in `try/finally` so `_join_multiline_values()`
always runs, even when DuplicateOptionError/DuplicateSectionError is raised.

In v3.15.2 the loop lives in `_read_inner`, and `_read` wraps it in
`try: ParsingError._raise_all(...) finally: self._join_multiline_values()`.
I reverted that to the pre-fix order: raise first, join afterwards
(`Lib/configparser.py`, `_read`). On an exception, values remain lists, so a later
`get()` fails with `AttributeError: 'list' object has no attribute 'find'`.

Oracle: `test_get_after_duplicate_option_error` (strict variants) fails this way.
