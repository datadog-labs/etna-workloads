# Rationale

Fix hunk reversed: `sqlite3Fts5ParseSetColset()` in `ext/fts5/fts5_expr.c`.
The fix replaced a direct `pParse->rc = SQLITE_ERROR; pParse->zErr = sqlite3_mprintf(...)`
with `sqlite3Fts5ParseError()`, which only sets the error if none is set yet.
I restored the direct assignment for the detail=none "column queries are not supported" error. If the parser has already recorded an error (e.g. a syntax error), `zErr` is overwritten, which leaks the first message and returns the wrong one.

The other fix hunks are not reverted. The added `assert( pParse->zErr==0 )` is an assertion only. The `detail!=full` hunk in `sqlite3Fts5ParseNode` already goes through `sqlite3Fts5ParseError()` in 3.54.1, and only the SetColset path is needed to reproduce the bug.

Oracle failure: `fts5detail-4.2` (`SELECT * FROM t4('a:a &')`) returns "column queries are not supported (detail=none)" instead of the syntax error near "&", and the run reports 32 bytes unfreed.
