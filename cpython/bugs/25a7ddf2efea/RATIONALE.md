# Rationale

Fix hunk reversed: the `self._validate_key_contents(key)` call in `RawConfigParser._write_section`
(Lib/configparser.py). In v3.15.2 `_validate_key_contents` and `InvalidWriteError` still exist,
but the call is removed, so `write()` once again emits keys that start with a section header
pattern or contain a delimiter, which `read()` parses back differently. The other fix hunks
(exception class, helper, `__all__`) are left in place; they are inert without the call.

Failing oracle cases: `InvalidInputTestCase.test_delimiter_in_key` and
`InvalidInputTestCase.test_section_bracket_in_key`. Both fail with
"AssertionError: InvalidWriteError not raised".
