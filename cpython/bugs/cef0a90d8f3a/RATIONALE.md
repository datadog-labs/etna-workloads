# Rationale

## Modules/_ctypes/stgdict.c (PyCStructUnionType_update_stginfo)
Reverses the fix's two stgdict.c hunks: `total_align` and `total_size` are
read from the layout object with `PyLong_AsInt` again instead of
`PyLong_AsSsize_t`. Sizes above INT_MAX then raise OverflowError instead of
being accepted (the fix's intent: limit is bits fitting in Py_ssize_t).
In v3.15.2 the variables are named `align_obj`/`size_obj` but the logic is the same.

The cfield.c hunk (assert / `bit_size_obj != Py_None` check) is already
different in v3.15.2 and is a debug-only assert change; not reverted.

## Oracle failures
`StructFieldsTestCase.test_max_field_size_gh126937` and
`UnionFieldsTestCase.test_max_field_size_gh126937` fail with
`OverflowError: Python int too large to convert to C int` when creating
`class Y` with `X * max_field_size`.
