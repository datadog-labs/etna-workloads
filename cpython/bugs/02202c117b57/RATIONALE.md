# gh-140551 reintroduced (Objects/dictobject.c)

Changes (reversing the fix's hunks):
1. `insert_combined_dict`: removed the "resize again to force general key kind if keys are unicode-kind and key is not exact str" block (fix hunk 1).
2. `insertdict`: restored the conversion to a general keys table *before* `_Py_dict_lookup` (the fix removed it, fix hunk 2). If `__eq__` called during lookup clears the dict, the keys become a fresh unicode-kind table and the non-str key is inserted into it unconverted.
3. `dict_setdefault_ref_lock_held`: same pre-lookup conversion restored (fix hunk 3).

The surrounding v3.15.2 code (split-table/else structure) already matched the post-fix shape, so only the pre-lookup conversion was put back and the post-lookup one removed.

Oracle: `test_clear_at_lookup` crashes the interpreter (the run is incomplete, so the other test_dict cases are also reported failing); this is the crash the fix guards against.
