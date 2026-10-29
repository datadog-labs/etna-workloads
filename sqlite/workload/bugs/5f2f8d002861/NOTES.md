repro.sql loads the corrupt tokendata=1 FTS5 database from fts5corrupt5-7.0 (via `.open --hexdb`) and runs the snippet()/highlight() query from test 7.1.

Clean shell: "Error near line 144: database disk image is malformed", exit status 1.
Buggy shell: crashes with SIGSEGV (exit status -11). The injection removes the `p->rc` check in fts5SetupTokendataIter(), so the loop keeps going after an error.
