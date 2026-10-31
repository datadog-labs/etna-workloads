# Rationale

Hunk reversed: `Python/structmember.c`, `PyMember_SetOne`, cases `Py_T_UINT` and `Py_T_ULONG`
(the fix's two implementation hunks). The 3.15.2 code converts with `_PyNumber_Index` and then
branches on sign. I restored the pre-fix logic: `PyLong_AsUnsignedLong(v)` first, and on any
failure `PyErr_Clear()` plus `PyLong_AsLong(v)` with the "Writing negative value" warning.
The `FT_ATOMIC_STORE_*` wrappers of the current code are kept.

Effects (the bugs the fix corrected):
- `PyLong_AsUnsignedLong` rejects non-int objects that only have `__index__`. The fallback then
  takes the "negative value" path, so `Index(0)` assigned to T_UINT or T_ULONG emits a spurious
  RuntimeWarning. A large `Index` value also raises OverflowError.
- A negative value assigned to T_UINT warns twice. The "negative" warning is followed by
  "Truncation of value to unsigned int", because `(unsigned long)-1 > UINT_MAX`.

Oracle: `test_int` and `test_long` in ReadWriteTests_NewAPI and ReadWriteTests_OldAPI fail
(4 errors). `Index(maxval)` raises "OverflowError: Python int too large to convert to C long".
