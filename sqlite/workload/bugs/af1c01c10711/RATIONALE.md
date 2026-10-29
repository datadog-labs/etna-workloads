# Rationale

Fix hunk: `src/vdbe.c` OP_IdxDelete, `r.flags = UNPACKED_PREFIX_MATCH` -> `r.flags = 0`
(reversed direction: the fix added the prefix-match flag).

In 3.54.1 the UnpackedRecord has no flags; prefix matching is expressed by
`r.default_rc = 0` (key compares equal when all supplied fields match). The
pre-fix `flags = 0` meant "no prefix match": a longer index entry (with trailing
rowid/PK columns) compared greater than the shorter key. I changed
`r.default_rc = 0` to `r.default_rc = 1` in OP_IdxDelete (src/vdbe.c), the equivalent.

For UNIQUE NOT NULL indices, sqlite3GenerateRowIndexDelete passes only nKeyCol
fields (P5), so the seek never finds the entry -> "database disk image is malformed"
(index corruption) during REPLACE.

Oracle failures: conflict2-14.1, 14.2 (malformed error, the cases the fix added),
plus conflict2-2.3, 2.4, 9.23-9.25 which exercise the same REPLACE/delete path.
