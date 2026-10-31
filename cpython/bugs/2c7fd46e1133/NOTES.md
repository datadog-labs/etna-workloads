# repro.py

Registers a custom decode error handler (`test.forward_shorter_than_end`) that,
for a `UnicodeDecodeError`, returns a 1-character replacement string together
with a new position of `exc.start + 1` — i.e. it advances less far into the
input than `exc.end`, leaving some of the originally-erroneous bytes still
unconsumed/to be reprocessed.

It then decodes `b'\xd8\xd8\xd8\xd8\xd8\x00\x00\x00'` as `'utf-16-le'` using
that error handler. Each lone/unpaired `\xd8\xd8` surrogate byte pair triggers
the error handler repeatedly, so the output buffer ends up being resized/grown
multiple times relative to the (too small) initial `min_length` estimate.

This exercises exactly the code path fixed by `fix.patch` in
`unicode_decode_call_errorhandler_wchar`/`writer`: before the fix, `inptr`
advances by `newpos` without accounting for `remain` (the bytes still left
between the old and new input pointer), so `writer->min_length` is not grown
enough when the handler returns a short `newpos`. This makes the writer
under-allocate, and subsequent writes to the unicode buffer go out of bounds.

## Observed difference

- `python-clean` (v3.15.2, unpatched): exits 0 and prints
  `'����\xd8\x00'` (as the repr with actual glyphs).
- `python-buggy` (injection.patch applied, reverting the fix): crashes with
  exit status -6 (SIGABRT). The debug allocator detects a corrupted trailing
  pad byte on the unicode string's underlying buffer
  (`_PyMem_DebugRawRealloc: bad trailing pad byte`), confirming a heap buffer
  overflow caused by the under-sized allocation.
