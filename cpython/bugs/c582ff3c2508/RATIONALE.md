# frozendict.fromkeys() for subclasses (gh-141510)

Fix hunk reversed: the "If cls is a frozendict subclass with overridden constructor, copy the frozendict" block in `_PyDict_FromKeys`.
In v3.15.2 this block had been rewritten (gh-151722): the copy only happens when the object returned by `cls()` is GC-tracked, and the copy is a plain `frozendict` that is later re-wrapped with `cls(d)`. I removed that copy block and the `need_copy` handling at `Done:`. `fromkeys()` now mutates whatever frozendict `cls()` returned in place, so a subclass whose `__new__` returns a shared frozendict has that shared object modified, and the result is not built via a subclass-friendly copy. This is the pre-fix behaviour.

The other fix hunks (asserts, `PyFrozenDict_Check` in the generic loop) were already present or are only asserts, so I left them.

Oracle: `FrozenDictTests.test_fromkeys` fails. The `can_modify_dict` assert fires on the shared frozendict and aborts the run, which takes down the rest of FrozenDictTests and the mapping test classes after it (39 cases reported failing in the incomplete run).
