repro.sh builds a small WAL db (page_size 1024), checkpoints it, then with cache_size=10 does
BEGIN; SAVEPOINT s; INSERT ... SELECT randomblob(900)...; ROLLBACK TO s; COMMIT (wal-21.2).
The writer wraps the log after the savepoint is opened. Clean shell: rows intact, integrity_check ok.
Buggy shell: assertion failure `aWalData[0]<=pWal->hdr.mxFrame` in sqlite3WalSavepointUndo (abort, exit 134).
