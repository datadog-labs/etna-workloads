# Rationale

## Change
`tree/ext/fts5/fts5_main.c`: `sqlite3Fts5TableFromCsrid()` no longer checks
whether `fts5CursorFromCsrid()` returned NULL; it dereferences `pCsr->base.pVtab`
unconditionally.

Reverses the fix hunk in `sqlite3Fts5IndexFromCsrid()` (adding `if( pCsr )` ... `return 0`).
That function was since refactored into `sqlite3Fts5TableFromCsrid()`, which is
called by `fts5VocabOpenMethod()` in fts5_vocab.c with a cursor id obtained from
the queried table. When the table is an fts3/4 table, the id is not an fts5
cursor, so the lookup returns NULL and the NULL dereference crashes.

## Oracle
`fts5vocab2-4.3.3` (fts3 table with an `INSERT ... '*id'` row so the query
returns an id that is not an fts5 cursor) segfaults; the run aborts, so
4.3.3 and later cases (5.x–8.x) are reported as failing.
