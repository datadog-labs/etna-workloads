# Rationale

Changed one hunk: `src/build.c`, `sqlite3TwoPartName()`.

Fix hunk reversed: the fix replaced `assert( !db->init.busy );` with a runtime
"corrupt database" error when a schema entry loaded during init
(`db->init.busy`) has a two-part name. In 3.54.1 that runtime check
still existed; I restored the pre-fix `assert( !db->init.busy );` on that path.
A corrupt sqlite_master row with a qualified name (e.g. `CREATE INDEX x.y ...`)
therefore trips the assert instead of reporting corruption.

The other fix hunks (`freeSpace`/`dropCell` corruption returns, `OP_OpenWrite`
`p2<2` check) are already assert-only or differently covered in 3.54.1 (CORRUPT_DB
handling), so they were not touched.

Oracle failure: `corruptC-2.12` aborts with
`sqlite3TwoPartName: Assertion '!db->init.busy' failed`; the run is then
incomplete, so the subsequent corruptC-2.x / 3.x cases fail too.
