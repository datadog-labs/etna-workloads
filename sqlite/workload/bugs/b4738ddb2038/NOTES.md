Reproducer: repro.sql loads the corruptL 2.0 database via `.open --hexdb` (index name in the
schema text patched s1x1->t1x1 so the shell's extra schema checks accept it), inserts the large
blob from test 2.1, then runs `SELECT length(b),c FROM t1 ORDER BY a`.

Difference: the select reaches a corrupt record with a huge size. The clean shell fails with
"Error: out of memory" (the amt>=SQLITE_MAX_ALLOCATION_SIZE check in vdbemem.c); the buggy shell
(check removed) reports "database disk image is malformed". Both exit 1; rows output are identical.
The test's actual assert() (CORRUPT_DB) can't be set via the shell (no never_corrupt testctrl).
