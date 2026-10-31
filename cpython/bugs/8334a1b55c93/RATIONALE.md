# gh-120384 reintroduced in list_ass_subscript_lock_held (Objects/listobject.c)

Hunk changed: in the "assign slice" branch, `adjust_slice_indexes()` (and the
`step == 1` → `list_ass_slice_lock_held(self, start, stop, value)` shortcut)
is moved back to *before* `PySequence_Fast(value)`. This reverses the fix hunk
that moved the `PySlice_AdjustIndices` call after the sequence is built.
The `step == 1` shortcut passes the original `value` again, as pre-fix code did.

Effect: an iterable `value` whose iteration mutates the list (e.g. clears it)
runs after `slicelength` was computed from the old `Py_SIZE`. For an extended
slice the size check passes against a stale length and the assignment loop
writes out of bounds (crash, as the issue describes).

Oracle: test_list_index_modifing_operand (expected ValueError, now crashes
the interpreter), and the run aborts so the remaining list tests are reported
as incomplete.
