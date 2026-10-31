# Rationale

One hunk changed, in `Lib/enum.py` `Enum.__new__` (by-value lookup, `except TypeError` branch).

Reverses the fix hunk `@@ -1166 ... __new__(cls, value)`: I removed the added fallback loop
`for name, member in cls._member_map_.items(): if value == member._value_: return cls[name]`.
The branch again searches only `_unhashable_values_map_`. An unhashable lookup value such as
`{"sc"}` is therefore never compared with members whose values are hashable, such as `frozenset({"sc"})`.

Other fix hunks, which maintain `_hashable_values_` and `__contains__`, are left in place.
Reverting `__contains__` as well broke about 23 unrelated tests, so it is not part of this bug.

Failing oracle case: `test.test_enum.TestSpecial.test_nonhashable_matches_hashable`.
`Directions({"sc"})` raises `ValueError: {'sc'} is not a valid ...Directions` instead of returning `DOWN_ONLY`.
