# Rationale (ticket #3482, malformed UTF16 -> UTF8 overrun)

Both changes are in `sqlite3VdbeMemTranslate()` in `tree/src/utf.c`.

1. Byte-swap path (UTF16le<->UTF16be): fix hunk changed `zTerm = &zIn[pMem->n]` to `&zIn[pMem->n&~1]`. Reverted to `&zIn[pMem->n]`, so an odd-length input has its last byte swapped with the byte past the end.
2. UTF16 -> UTF8 length computation: fix hunk added `pMem->n &= ~1;` before sizing the output buffer. Removed it (it is still present in 3.54.1 in the same place), so an odd `n` is kept and the translator reads a partial trailing code unit.

## Oracle
`utf16align-2.1` fails: expected `6EFC`, got `6EFCFFFD`. The trailing odd byte is decoded as a bogus character (U+FFFD) instead of being dropped. Other cases pass.
