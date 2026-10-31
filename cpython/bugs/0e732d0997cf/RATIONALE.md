# Rationale

Fix (gh-112625) wrapped `stringlib_bytes_join` in `bytearray.join` with `self->ob_exports++/--`
so a custom iterator cannot clear/resize the bytearray mid-join.

In v3.15.2 the method is `bytearray_join_impl` in Objects/bytearrayobject.c (clinic-generated wrapper).
I removed the `ob_exports++` / `ob_exports--` pair and the `ret` temporary, restoring the pre-fix
`return stringlib_bytes_join((PyObject*)self, iterable_of_bytes);`. This is the exact inverse of the single
implementation hunk.

Oracle: `test_bytearray_join_with_misbehaving_iterator` fails ("BufferError not raised by join"), since the
bytearray can be cleared during iteration (use-after-free risk). The custom-iterator test still passes.
