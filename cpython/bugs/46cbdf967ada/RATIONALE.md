# gh-135228 re-injection

The fix's `Lib/dataclasses.py` hunks (popping `__dict__` and deleting `__weakref__` from the original class's dict) are not present in v3.15.2, yet the original class was still collected. 3.15 solved it in C instead. `type_add_common_descriptor()` in `Objects/typeobject.c` installs shared, cached `__dict__`/`__weakref__` getset descriptors whose `d_type` is `object`, so the old class's dict no longer refers back to the class.

## Change (Objects/typeobject.c)
`type_add_common_descriptor()` now creates a fresh `PyDescr_NewGetSet(type, ...)` for each class instead of using the per-interpreter cached descriptor owned by `object`. Both callers in `type_new_descriptors` were updated, and the unused `interp` local was removed.

This puts back the pre-fix state the fix worked around. The old class's tp_dict holds `__dict__`/`__weakref__` descriptors that point at the class itself. The `__classdict__` cell of the copied `__annotate_func__` keeps that tp_dict alive from the new class. The new class therefore keeps the original alive: tp_dict -> descriptor -> class. Removing those entries (the fix hunk) broke this chain, and so did sharing the descriptors.

## Oracle failures
`TestSlots.test_original_class_is_gced` fails in 3 subtests. `object.__subclasses__()` still contains both the original and the replacement `SlotsTest` class.
