repro.sql loads the corrupt fts5 database from test fts5corrupt3-76.0 (via `.open --hexdb`) and runs `SELECT * FROM t4;` (an fts5vocab table over a corrupt fts5 index).

Clean: "database disk image is malformed", exit 1.
Buggy: segfault (exit -11), because fts5 `iLeafOffset` is an int instead of i64, so an overflowing offset indexes out of bounds.
