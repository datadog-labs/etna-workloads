# Rationale

Changed `ext/fts5/fts5_index.c`, `sqlite3Fts5IndexQuery()`.

The fix moved `if( flags & FTS5INDEX_QUERY_NOTOKENDATA ) bTokendata = 0;` out of the
`#ifdef SQLITE_DEBUG` block and made it also cover `FTS5INDEX_QUERY_SCAN`. In 3.54.1 that is
the unconditional `if( flags & (NOTOKENDATA|SCAN) ){ bTokendata = 0; }` block. I removed it
and restored the pre-fix line, which exists only under `SQLITE_DEBUG` and only checks NOTOKENDATA.

The effect is the pre-fix behaviour. fts5vocab scans (QUERY_SCAN) on a tokendata=1 table go
through fts5SetupTokendataIter on corrupt data, and in non-debug builds NOTOKENDATA is ignored.

Oracle failure: fts5vocab2-6.2 aborts with `fts5VocabNextMethod: Assertion 'nTerm>=0' failed`
instead of returning "database disk image is malformed".
