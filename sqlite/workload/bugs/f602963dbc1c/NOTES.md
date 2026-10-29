repro.sh: connection 1 (shell on a fifo) opens an empty test.db; connection 2 sets
page_size=1024, switches to WAL and creates a table. Connection 1 then runs
`PRAGMA page_size=4096; VACUUM;` (wal8-1.1).
Clean: VACUUM succeeds, exit 0. Buggy: "Error near line 2: attempt to write a
readonly database", exit 1 (VACUUM changes the page size before taking its lock).
