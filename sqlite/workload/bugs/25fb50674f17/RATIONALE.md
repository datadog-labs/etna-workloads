# Rationale

Changed `ext/fts5/fts5_vocab.c`, `fts5VocabResetCursor()`: removed `pCsr->bEof = 0;`.

This reverses the fix hunk that added `pCsr->bEof = 0;` to `fts5VocabResetCursor`.
Without it, a vocab cursor that reached EOF keeps `bEof==1` when it is rescanned
(e.g. as the inner loop of a join of two fts5vocab tables over the same fts5 table),
so the inner scan returns no rows.

Other hunks of the fix (Fts5Table/pFts5 refactor, flush-to-disk in xOpen) are
already present in 3.54.1 and were left alone; only this one-line omission is restored.

Oracle failure: `fts5vocab-10.3` (join of fts5vocab tables t2/t3 over `ft`) fails
with a wrong result (1 error out of 567 tests).
