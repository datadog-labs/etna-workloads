# Rationale

Fix hunk (Objects/dictobject.c, `insertdict`): in the "replace existing value" path, the fix removed `assert(!_PyDict_HasSplitTable(mp))` and added a split-table branch using `STORE_SPLIT_VALUE`.

In v3.15.2 that code lives in `replace_value()` (Objects/dictobject.c). I reverted it to the pre-fix form: re-added `assert(!_PyDict_HasSplitTable(mp))` and removed the split-table branch, so a unicode-keys dict always stores through `DK_UNICODE_ENTRIES(...)[ix]`. For a split table that indexes into the shared keys entries instead of `ma_values`, which is the original bug. It is reached when a non-exact `str` key (e.g. a `str` subclass) matching an existing key is inserted into an instance `__dict__`.

## Oracle failures
`test_split_table_update_with_str_subclass` fails. The run crashes (assert/segfault), so many later cases in test_dict.py are reported as failing as well (incomplete run).
