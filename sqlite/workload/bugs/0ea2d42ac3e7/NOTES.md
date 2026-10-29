Reproducer: repro.sh. Builds a UTF-16le database (u16.db), opens test.db as UTF-8 with its schema loaded, then
overwrites test.db from u16.db via an external process (`.shell sqlite3 u16.db ".backup test.db"`), and queries t2.

Clean: "attached databases must use the same text encoding as main database" (exit 1).
Buggy: the encoding change is silently accepted and the query returns d|e|f.
