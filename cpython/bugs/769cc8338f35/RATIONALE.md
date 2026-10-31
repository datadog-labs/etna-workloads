# Rationale

Fix hunk reversed: the `TABLE_ENTRY_SW(D, ...)` / `TABLE_ENTRY_SW(F, ...)` additions in `Modules/_ctypes/cfield.c`.
In v3.15.2 the complex codes are renamed `Zd`/`Zf`, so I removed the `TABLE_ENTRY_SW(Zd, ...)` and `TABLE_ENTRY_SW(Zf, ...)` lines
(`Modules/_ctypes/cfield.c`, the complex block of the fielddesc table). Only the plain `TABLE_ENTRY` remains, so these
types again have no swapped get/set functions and no `__ctype_le__/__ctype_be__` attributes.
The other fix hunks (`set_stginfo_ffi_type_pointer` helper, `Zd_set_sw` etc. definitions) are left in place; the helper was a
refactor/robustness fix and the `_sw` functions are simply unused now.

Oracle failures: `test_endian_float_complex` and `test_endian_double_complex` fail with
`AttributeError: type object 'c_float_complex' has no attribute '__ctype_le__'` (likewise for c_double_complex).
