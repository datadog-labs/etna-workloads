# Rationale

Only `tree/Lib/typing.py`, `_TypedDictMeta.__new__`, was changed. It restores the pre-fix logic from gh-112509.

- Base loop: the fix's `base_required`/`base_optional` merging, which removed keys from the opposite set, is replaced by plain `required_keys.update(...)` and `optional_keys.update(...)`. A key that is optional in one base and required in another can then end up in both sets.
- Own annotations: the `is_required` computation with `discard` on the opposite set is replaced by the old `if Required / elif NotRequired / elif total / else` chain with `add` only. A subclass that redefines a key with the opposite requiredness leaves the key in both sets.
- The added `assert required_keys.isdisjoint(optional_keys)` is removed. The fix introduced it, so the old code had no such check.

Oracle cases that fail: `test_keys_inheritance_with_same_name` and `test_multiple_inheritance_with_same_key`. Both report keys present in both `__required_keys__` and `__optional_keys__`. Ran with `./check.sh`: 2 failures out of 742 tests.
