repro.sql opens the corrupt FTS5 database from fts5corrupt3 test 17.0 (via `.open --hexdb`) and runs `SELECT ... MATCH 'abandon'`.
The structure record has a huge nLevel/nSegment varint.
Clean shell: `fts5: corrupt structure record for table "t1"`.
Buggy shell (range check removed): `out of memory`, since fts5StructureDecode tries to allocate a huge structure.
Both exit with status 1.
