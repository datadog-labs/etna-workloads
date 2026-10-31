# Rationale

Fix hunk reversed: the `_add_slots` loop that rewrites `__class__` closure cells
(and the helper `_update_func_cell_for__class__` call sites for functions,
wrapped functions and property fget/fset/fdel) so zero-arg `super()` / `__class__`
point to the new slotted class. In v3.15.2 the loop sits in `Lib/dataclasses.py`
`_add_slots` (with an extra `__wrapped__` guard); I removed the whole loop, which
is the pre-fix behaviour. The helper function stays, since the later
`__annotate__` fix-up in v3.15.2 still uses it (unrelated to this bug).

Oracle failures: all TestZeroArgumentSuperWithSlots cases (zero_argument_super,
wrapped, property getter/setter/deleter, old/new property, remembered_class) fail
with `super(type, obj): obj must be an instance or subtype of type` or
`__class__ is not type(self)`. Also failing: TestSlots.test_original_class_is_gced,
TestFrozen.test_frozen_empty and test_non_frozen_normal_derived (same stale cell).
