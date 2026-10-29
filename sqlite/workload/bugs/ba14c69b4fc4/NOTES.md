Reproducer for corruptL-5.1: `repro.sh` loads the test's corrupt database (via `.open --hexdb`) with the pending-byte page moved to 0x10000 (`.testctrl pending_byte`, which needs `-unsafe-testing`, so this is a .sh, not a .sql). It then runs `INSERT INTO t1(b) VALUES(zeroblob(40000))`.

Clean: "database disk image is malformed", exit 1. Buggy: the assert `*pPgno!=PENDING_BYTE_PAGE(pBt)` in allocateBtreePage fails (the injection removed `CORRUPT_DB ||`), and the shell aborts with exit 134.
