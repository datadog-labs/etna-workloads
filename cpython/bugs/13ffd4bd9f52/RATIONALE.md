# Rationale (gh-116040)

Fix hunk reversed: `EnumType.__call__` lookup condition `if names is not _not_given:` -> `if names:` (Lib/enum.py).
Pre-fix, a falsey second positional value (e.g. `Cardinal(1, 0)`) was dropped, so the lookup used `1` instead of `(1, 0)`.

Supporting change: v3.15.2's `_not_given` sentinel was truthy; the fix added `__bool__ -> False` to it. Added that method so
the default `names=_not_given` stays falsey under `if names:` (otherwise every plain lookup breaks, not just this bug).

Oracle: test_enum fails (1 error) - the by-value call with a falsey second value (the test added by the fix) no longer finds the member.
