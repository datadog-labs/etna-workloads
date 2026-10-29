repro.sh creates a file DB with 8192-byte pages, then in a non-empty :memory: DB with 1024-byte pages runs `.restore main src.db` (a backup into an in-memory destination with a different page size).
Clean: "attempt to write a readonly database", exit 1. Buggy: assertion failure in backupOnePage (abort, exit 134); in a non-debug build this is the upstream segfault.
