Starts a master and a replica, creates a stream group at `$`, and runs three `XREADGROUP ... COUNT 1` reads, so some are served by the XCLAIM path. It then waits for replication and prints `entries-read` and `lag` from `XINFO STREAM s FULL` on both servers.

Clean build: master and replica both print `entries-read 3 lag 0`.
Buggy build: the replica's `entries-read` is nil. XREADGROUP no longer propagates `XGROUP SETID ... ENTRIESREAD` unless NOACK is given, so the replica's counter is never updated.
