# Rationale

## Hunk changed: `fts5SegIterNext_Reverse` in `tree/ext/fts5/fts5_index.c`
Reverses the single implementation hunk of fix.patch. The reverse-iteration path again
reads the previous rowid delta from the raw `aRowidOffset` entry, using
`fts5GetPoslistSize()` to skip the poslist only when detail!=none, and calls
`fts5SegIterLoadNPos()` after the delta is read. With detail=none, the offset is not
advanced past the delete-marker/zero bytes that `fts5SegIterLoadNPos()` would skip, so the
delta is read from the wrong byte. A deleted entry (a 0x00 marker) gets read as a rowid delta of 0.
The result is wrong rowids and deleted rows showing up.

## Oracle failures
- fts5simple2-15.3.2: `SELECT rowid FROM t1('sqlite') ORDER BY rowid DESC` after DELETE returns [1], expected [].
- fts5simple2-15.4: integrity-check reports "database disk image is malformed".
- fts5simple2-16.2: wrong result list ([1000 1000 1000 456 1] vs [1000 456 1]).
