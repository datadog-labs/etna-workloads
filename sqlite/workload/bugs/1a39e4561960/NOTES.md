repro.sh builds a WAL-mode db (page_size 8192), truncates the file to 20KB, opens it with `.open --deserialize`, writes in exclusive mode, then runs `PRAGMA wal_checkpoint`.
Clean: "database disk image is malformed" (memdbTruncate returns SQLITE_CORRUPT). Buggy: assertion failure in memdbTruncate (NEVER(size>p->sz)), abort, exit 134.
