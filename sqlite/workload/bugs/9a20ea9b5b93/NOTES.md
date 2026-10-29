Reproducer: repro.sh (from fts3corrupt4 test 28.0-28.3).
It rebuilds the test's corrupt 28 KB FTS3 database from its hexdump (awk + xxd -r),
opens it with `.dbconfig defensive off` and `writable_schema on` (the shell's
defensive default and the PRAGMA alone are not enough to load the corrupt schema),
then runs two big `INSERT ... randomblob(2829)` statements, with an UPDATE in between.

clean: both INSERTs fail with "database disk image is malformed", exit status 1.
buggy: the injection weakens the freeblock check in btreeComputeFreeSpace
(pc<iCellFirst instead of pc<top, and it drops the size<4 check), so the corruption is
missed, both INSERTs succeed silently and the exit status is 0.
