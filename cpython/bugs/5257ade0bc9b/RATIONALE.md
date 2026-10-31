# Rationale

Fix hunk: Lib/typing.py added `'__match_args__'` to `_SPECIAL_NAMES` so it is excluded from protocol members.
In v3.15.2 the name is still in `_SPECIAL_NAMES` (Lib/typing.py, feeding `EXCLUDED_ATTRIBUTES`); I removed it again, restoring the pre-fix set.

Oracle: `test_typing` `test_runtime_checkable_with_match_args` fails. `__match_args__` becomes a protocol member, so `Regular(1, 2)` is no longer an instance of `P_match`.
