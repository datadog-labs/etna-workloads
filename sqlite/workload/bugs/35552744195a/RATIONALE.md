# Rationale

Fix: corrupt-database crash in fts3 `offsets()` (missing corruption checks).

## Changes (tree/)
1. `ext/fts3/fts3.c`, `sqlite3Fts3EvalPhrasePoslist()`: removed the
   `if( rc==SQLITE_OK && pRun->bEof!=bEofSave ) rc = FTS_CORRUPT_VTAB;` check
   (reverses hunk 1; variable is `pRun` instead of `pNear` today).
2. `ext/fts3/fts3_snippet.c`, `sqlite3Fts3Offsets()`: the return code of
   `sqlite3Fts3ExprIterate(..., fts3ExprTermOffsetInit, ...)` is discarded
   again (`(void)`), reversing hunk 2.
3. `ext/fts3/fts3.c`, `sqlite3Fts3MsrCancel()`: the loop used to raise
   `FTS_CORRUPT_VTAB` when the expression hit EOF without finding the docid. This
   is the second path covering the same case (reverting 1+2 alone left 51.1
   passing because this path reports corruption first). I replaced that check
   with a loop-exit on `bEof`, so EOF is silently accepted: same defect
   (EOF-on-corrupt-doclist not reported). Simply deleting the check hangs forever.

## Oracle
`fts3corrupt4-51.1` fails (expected `1 {database disk image is malformed}`;
the corrupt query no longer reports corruption). Other oracle cases pass;
`fts3offsets` 1.5.x (non-corrupt) is unaffected, as expected.
