Reproducer: `repro.sh` (walcksum-4.x). In WAL mode with cache_size=1, a savepoint spills dirty pages
into the WAL, is rolled back, and more is written before RELEASE. The WAL is then copied while the
connection is still open (so no checkpoint) and the copy is opened in a fresh shell.

Clean: the copy returns `1|one` and `8|eight`.
Buggy: the stale iReCksum is not reset on savepoint rollback, so frames are written with bad
checksums. Recovery of the copy stops early, and the row `8|eight` is missing (only `1|one`).
