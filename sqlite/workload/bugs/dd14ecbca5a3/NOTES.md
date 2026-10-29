Opens a transaction, reads sqlite_master (loads page 1), then runs `PRAGMA page_size=2048`.
The fix removed a faulty `assert(!pBt->pPage1)` in sqlite3BtreeSetPageSize.
Clean shell: prints 1024; buggy shell: assertion failure/abort.
