# Rationale

Fix hunk reversed: `Modules/_ctypes/_ctypes.c` / `cfield.c` — "generate SIMPLE_TYPE_CHARS once at runtime".
Before the fix the error message listed a compile-time constant `SIMPLE_TYPE_CHARS`
(always containing `X`, regardless of which types were actually registered).
The fix built the list from the populated `formattable`.

In v3.15.2 that code was reshaped (complex types are now `Zf/Zd/Zg`, the list is
generated in `_ctypes_init_fielddesc`). The change: `_ctypes_get_simple_type_chars()`
in `Modules/_ctypes/cfield.c` returns a static literal `"cbBhHiIlLdfuzZqQPXOv?g"`
instead of the runtime-generated `formattable.simple_type_chars`. The message
then advertises `X` on non-Windows platforms, where it is not a supported type.

Failing oracle case: `test_bad_type_message` (message contains `...QPXOv?g`
instead of `...QPOv?g`). The other 8 cases still pass.
