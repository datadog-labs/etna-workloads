# Ticket #2285 reintroduced

Fix: in sqlite3PagerAcquire(), a cache hit for a page beyond the end of the
database (pgno > dbSize, left over after a truncation/rollback in exclusive
mode) is zeroed before being returned.

In 3.54.1 getPageNormal() returns cached pages unchanged (no zeroing), and the
same case is instead prevented by `sqlite3PcacheTruncate(pPager->pPCache,
pPager->dbSize)` in pager_end_transaction(), which drops cached pages past
EOF. That is the same defect covered from another path, so I removed that call
(src/pager.c, pager_end_transaction). Stale pages beyond EOF then remain in
the cache and are returned with old content, as before the fix.

Oracle failures (test/tkt2285.test): tkt2285-1.2, 2.1, 2.2 fail with
"database disk image is malformed" (stale page 1/2 content returned after
ROLLBACK of CREATE TABLE in exclusive locking mode). 1.1 still passes.
