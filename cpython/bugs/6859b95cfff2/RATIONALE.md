# gh-135228 re-injection

In v3.15.2 `Lib/dataclasses.py::_add_slots` already pops `__dict__`/`__weakref__`
from the copied dict (the pre-fix code), and `sys._clear_type_descriptors` is
absent, so the fix's hunks cannot be reversed. The original class stays
collectible only because `type_new` now installs *shared* `__dict__` /
`__weakref__` getset descriptors owned by `object`, so the original class's own
namespace (kept alive through the `__annotate__`/`__classdict__` cell copied
into the slotted class) no longer references the original class.

## Change (Objects/typeobject.c, `type_add_common_descriptor` and its two callers)
Restores per-type descriptors: each class gets its own `__dict__` / `__weakref__`
getset descriptor whose `__objclass__` is that class (no interpreter-wide cache).
This recreates the exact reference the fix removed with
`sys._clear_type_descriptors(cls)`: original class dict -> descriptor -> original class,
reachable from the new class via the copied `__annotate_func__` / class-dict cell,
so the original class is never collected.

## Oracle
`TestSlots.test_original_class_is_gced` fails (3 failures across subtests, e.g.
`make_with_forwardref`): `object.__subclasses__()` still lists the original
`SlotsTest` in addition to the replacement.
