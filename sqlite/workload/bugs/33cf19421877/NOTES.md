repro.sql loads the corrupt FTS5 database from fts5corrupt5-3.1 (via `.open --hexdb`) and runs
`UPDATE t1 SET b=quote(zeroblob(200)) WHERE a MATCH 'thra*T';`.

Clean shell: exit 1, "fts5: corruption on page 1, segment 1, table "t1"".
Buggy shell: segfault (exit -11), because fts5LeafSeek uses signed ints, which overflow on the corrupt varint.
