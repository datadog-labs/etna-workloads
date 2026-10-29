# Rationale

Only `ext/fts5/fts5_index.c` (`fts5LeafSeek`) changed. The 3.54.1 tree already had the fix's
unsigned/`(i64)` conversions there, so I reverted them to the pre-fix signed `int` types.

- Hunk 1 (declarations): `iOff`, `n`, `iPgidx` go back to `int`, and `szLeaf` is a local `int` again. Because the offsets are signed, a corrupt varint above INT_MAX wraps negative and passes the `iOff>n` and `iPgidx>=n` checks.
- Hunk 2 (`iPgidx = szLeaf`) and the `iPgidx = pIter->pLeaf->szLeaf` / `n = pIter->pLeaf->nn` assignments in the end-of-page loop go back to plain signed assignments.
- Hunk 3: `(i64)iOff>=szLeaf` goes back to `iOff>=szLeaf`, a signed comparison.

The hunks in `fts5_buffer.c` only removed asserts that are always true for `u32`. I did not restore them.

## Oracle result
`./check.sh`: 35 of 40 oracle cases fail. `fts5corrupt5-3.1` (the case the fix added) runs the `UPDATE` on the corrupt db and crashes the run. The later cases never run, so they are counted as failing too.
