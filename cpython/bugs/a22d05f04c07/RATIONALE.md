# Rationale

Hunk reversed: `_get_slots` in Lib/dataclasses.py (fix hunk: `case None: return` -> `yield from ('__dict__', '__weakref__')`).

v3.15.2 computes the `None` case from `__weakrefoffset__`/`__dictoffset__`. I restored the pre-fix
`case None: return`, so a base class without `__slots__` contributes no inherited slots. A slotted
dataclass with `weakref_slot=True` deriving from such a base then adds `__weakref__` a second time.
That is the gh-105866 failure.

Failing oracle cases: `TestSlots.test_dataclass_derived_weakref_slot` (the fix's test, a layout/duplicate
`__weakref__` error) plus two others, including `test_dataclass_derived_generic_from_base`
(`__slots__` is `('__weakref__',)` instead of `()`).
