# Rationale

v3.15.2 `Lib/logging/__init__.py` already had the fix's code (plus a later rounding guard). Reverted to the pre-fix float-based `time.time()` computation:

- `_startTime = time.time_ns()` -> `time.time()` (fix hunk @@ -56).
- `LogRecord.__init__`: `ct = time.time_ns()` -> `time.time()` (hunk @@ -300).
- `created = ct`, `msecs = int((ct - int(ct)) * 1000) + 0.0`, `relativeCreated = (created - _startTime) * 1000` (hunk @@ -339). This also removes the later `msecs == 999.0` rounding guard, which only exists to patch the ns-based code path.

Docs/docstring hunks are not reverted (not implementation).

## Oracle failures
`FormatterTest.test_msecs_has_no_floating_point_precision_loss` and `test_relativeCreated_has_higher_precision` fail (8 failures total in test_logging): the records no longer use the patched `time.time_ns`, and msecs/relativeCreated lose floating point precision.
