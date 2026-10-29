repro.sh enables SQLITE_FCNTL_PERSIST_WAL (`.filectrl persist_wal 1`) on a WAL database, then runs
journal_mode=TRUNCATE, MEMORY, WAL, PERSIST in sequence (the walpersist-4.1 sequence).
Clean shell prints all modes and exits 0. Buggy shell hits the assertion
`pPager->eLock==SHARED_LOCK || pPager->eLock==EXCLUSIVE_LOCK` in pagerExclusiveLock
and aborts (exit 134) on the last PRAGMA.
