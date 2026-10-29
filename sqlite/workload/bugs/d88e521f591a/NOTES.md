repro.sql opens two shared-cache connections (via `.connection`/`.open` on a shared in-memory URI).
Connection 0 creates and reads an fts3 table. Connection 1 drops it, which puts connection 0's
vtab on its disconnect list. `.connection close 0` then closes connection 0.

Clean: closes silently. Buggy (missing sqlite3VtabUnlockList in disconnectAllVtab):
"sqlite3_close() returns 5: unable to close due to unfinalized statements" plus "Memory leaked".
