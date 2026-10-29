# Rationale

Fix hunk: `ext/fts3/fts3_aux.c`, `fts3auxNextMethod`, state 3. The fix replaced the
column-number bound `iCol>0x3fffffff` with `iCol>(pFts3->nColumn+1)`.

In 3.54.1 that line already read `iCol>32767` (an intermediate bound), so the fix
hunk could not be reversed textually. I restored the pre-fix bound `iCol>0x3fffffff`
in the same place. A corrupt segment holding a huge column number (varint
`FFFFFF7F` = 0x0fffffff) then passes the check and `fts3auxGrowStatArray` is asked
for ~268M entries. That is the oversized allocation the fix guards against. On
32-bit size_t the size multiplication overflows, which gives the buffer overwrite.

Oracle failure: `fts3corrupt7-4.4` expects `database disk image is malformed` and
gets `out of memory`. On a 64-bit build the huge realloc fails, so there is no overwrite.
