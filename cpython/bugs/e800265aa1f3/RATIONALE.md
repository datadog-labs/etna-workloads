# Rationale

Fix hunk reversed: in `_read`, the check `if cursect[optname] is None: raise MultilineContinuationError(...)` before appending a continuation line.
In v3.15.2 this logic lives in `RawConfigParser._handle_continuation_line` (Lib/configparser.py); I removed the same check, so a continuation line after a valueless key (allow_no_value=True) again goes straight to `.append` on `None`.
(The `MultilineContinuationError` class and docs are left in place; only the raising behaviour is reverted.)

Failing oracle: `test_keys_without_value_with_extra_whitespace` — it now errors with `AttributeError: 'NoneType' object has no attribute 'append'` instead of raising `MultilineContinuationError`.
