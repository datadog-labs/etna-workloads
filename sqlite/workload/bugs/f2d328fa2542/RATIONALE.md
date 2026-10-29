# Rationale

Fix hunk reversed: in `sqlite3Fts5HashWrite()` (ext/fts5/fts5_hash.c), the fix replaced
the nul-terminator test `p->zKey[nToken+1]==0` with a length comparison `p->nKey==nToken`.

In 3.54.1 the key length is already stored (`nKey`, counting the leading byte, so
`p->nKey==nToken+1`). I restored the old lookup: the `nKey` comparison is removed and the
`zKey[nToken+1]==0` test is back after the memcmp. A stored key shorter than the probe token
is then memcmp'd past its end (the buffer overread), and tokens containing embedded NULs can
falsely match. The `nKey` field and its other uses are left alone, since the
fix's other hunks (adding the field, `i16`) are already in 3.54.1 and aren't part of the defect.

Oracle: all 22 cases in fts5hash.test fail. The run aborts at fts5hash-full-1.0 with
`fts5HashEntryMerge: Assertion 'cmp!=0' failed`, because duplicate hash entries are created.
