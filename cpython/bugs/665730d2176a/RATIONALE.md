# Rationale

Fix (bpo-23224) moved the bz2/lzma compressor/decompressor setup from
`__init__` (with `PyType_GenericNew`) to `__new__`, so an object can never be
used uninitialized and repeated `__init__` can't leak. In v3.15.2 the code is
already `__new__`-based, so I reverted only `_bz2.BZ2Decompressor`:

- `Modules/_bz2module.c`: replaced the clinic `BZ2Decompressor.__new__`
  (`_bz2_BZ2Decompressor_impl`) with the hand-written `__init__`
  (`_bz2_BZ2Decompressor___init__`), including `Py_XSETREF(unused_data, ...)`,
  and slots `Py_tp_init` + `PyType_GenericNew` + the old doc string. This
  reverses the fix's BZ2Decompressor hunks (`__init__` -> `__new__`, slots).
- `Modules/clinic/_bz2module.c.h`: removed the generated `BZ2Decompressor`
  `__new__` wrapper/doc, as the fix's generated-file hunk added them.

Not reverted: Compressor classes, lzma, and module state (unrelated to the bug).

## Oracle
`test_bz2.BZ2DecompressorTest.test_uninitialized_BZ2Decompressor_crash` fails:
`BZ2Decompressor.__new__(BZ2Decompressor).decompress(b'')` raises
`ValueError: Internal error - invalid parameters passed to libbzip2`
instead of returning `b''` (an uninitialized object is usable again).
