# Rationale

All three fix hunks (ext/fts5/fts5_index.c) still apply conceptually to 3.54.1; the
tree already had the fixed `i64` types, so I reverted them to `int`:

1. `Fts5SegIter.iLeafOffset`: `i64` -> `int` (reverses hunk 1).
2. `fts5SegIterLoadRowid()`: local `iOff` `i64` -> `int` (reverses hunk 2).
3. `fts5SegIterLoadTerm()`: local `iOff` `i64` -> `int` (reverses hunk 3).

With 32-bit offsets, a corrupt varint-derived offset overflows/wraps and indexes
the leaf buffer out of range (segfault with an fts5vocab/fts5token table on corrupt data).

## Oracle
`fts5corrupt3-76.1` (`SELECT * FROM t4` on the corrupt db) now crashes the
testfixture, so 76.1 and all following cases (77.0 ... 84.1, 20 in total) fail as the run is incomplete.
