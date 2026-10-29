repro.sql loads the corrupt database from fts5corrupt3 test 81.0 (via `.open --hexdb`) and runs `UPDATE t1 SET b=zeroblob(299);` (test 81.2).
Clean: "database disk image is malformed", exit 1. Buggy: assertion `p->pSavedRow' failed in sqlite3Fts5StorageContentInsert (abort, exit -6).
