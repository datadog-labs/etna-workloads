# Rationale

Changed only `Modules/_remote_debugging/object_reading.c`, `read_py_str()`.

Fix hunk reversed: the rewrite of `read_py_str` that inspects `state`
(compact/ascii/kind), builds the result with `PyUnicode_New(len, max_char)`,
and copies `len * kind` bytes from the right header size. I restored the
pre-fix body: allocate `len+1` bytes, read `len` bytes at `asciiobject_size`,
and call `PyUnicode_FromStringAndSize` (UTF-8 decode), with the original
`goto err` / `PyMem_RawFree` cleanup. The later `max_len` clamp (gh-157788)
is kept, since it is unrelated to the fix.

Left alone: the `compactunicodeobject_size` offset and its validation are
still present but unused. They are harmless and are not the bug itself.

## Oracle failure
`TestGetStackTrace.test_remote_stack_trace_non_ascii_names` fails. Latin-1,
2-byte and 4-byte strings are read as raw UTF-8 bytes from the wrong offset,
so filenames and function names come back as garbage with NULs, and the
frame for the non-ASCII function name is missing. The other 63 cases pass.
