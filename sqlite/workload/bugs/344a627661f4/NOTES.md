The bug is about handling of malloc failure in prepare/parse. The shell has no
fault-injection hook, so repro.sql uses `PRAGMA hard_heap_limit=90000` to cause a
genuine out-of-memory during parsing of the later statements.

Clean shell: reports "Parse error near line 5: out of memory (7)" and exits 1.
Buggy shell: the parser no longer forces rc=SQLITE_NOMEM after mallocFailed, so
sqlite3LockAndPrepare hits `Assertion rc==SQLITE_OK || (*ppStmt)==0` and aborts (exit 134).
The exact heap limit is tuned to this build; it is deterministic for it.
