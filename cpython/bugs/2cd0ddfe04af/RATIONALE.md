# Rationale

## Objects/dictobject.c, dictitems_xor_lock_held
The fix changed `copy_lock_held(d1, PyFrozenDict_Check(d1))` to `copy_lock_held(d1, 0)`.
In v3.15.2 the call is `copy_lock_held_untracked(d1, 0)`; I restored the
pre-fix second argument: `copy_lock_held_untracked(d1, PyFrozenDict_Check(d1))`.
For a frozendict `d1`, the scratch `temp_dict` is therefore a frozendict, and the
later `PyDict_DelItem` on it raises `TypeError: frozendict object does not support item deletion`.

## Oracle failures
`test.test_dict.FrozenDictTests.test_items_xor` errors with that TypeError
(`frozendict(a=1,b=2).items() ^ frozendict(b=2,c=3).items()`).
