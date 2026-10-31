# Rationale

Changed `_get_slots` in `Lib/dataclasses.py` (the `case None:` branch), reversing the
fix's only implementation hunk. The offset-based checks (`__weakrefoffset__` /
`__dictoffset__`) are replaced with the pre-fix behaviour: a class with no `__slots__`
is assumed to be `('__dict__', '__weakref__')`. (v3.15.2 had the corrected `__dictoffset__`
spelling, so the hunk would not reverse textually.)

Effect: for a base such as `typing.Generic` (which defines `__slots__ = ()`) or a slotted
base, the inherited slots are wrong, so `__weakref__` / `__dict__` are treated as already
inherited and are not created. This is the gh-118033 failure.

Oracle: `check.sh` reports 3 failures in test_dataclasses, including
`test_dataclass_slot_dict_ctype` (`__slots__` is `()` instead of `('__dict__',)`).
