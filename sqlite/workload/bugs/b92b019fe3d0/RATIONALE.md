# Rationale

Both fix hunks still revert cleanly in spirit; the pre-fix code is restored.

1. `ext/fts5/fts5_index.c`, `fts5SegIterLoadTerm()`: removed the `|| nNew==0`
   term from the corruption check (reverses the fix's first hunk). A zero-length
   new-term suffix is again accepted, so a corrupt leaf yields an iterator term
   that is not rejected, and fts5vocab reads past the buffer / misbehaves.
2. `ext/fts5/fts5_vocab.c`, `fts5VocabNextMethod()`: removed the added
   `assert( nTerm>=0 )` (reverses the second hunk; assert-only).

Failing oracle cases: fts5corrupt3-49.1 (the case added by the fix) and
fts5corrupt3-50.1. Both expect "database disk image is malformed" for an
fts5vocab query on a corrupt db and no longer get it.
