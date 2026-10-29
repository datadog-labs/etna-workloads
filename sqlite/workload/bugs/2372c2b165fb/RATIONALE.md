# Rationale

Fix (CVS 3312, ticket #1873) added a check in `detachFunc` (src/attach.c) so
DETACH fails with "database %s is locked" if the database has any open
transaction, read or write (`sqlite3BtreeIsInReadTrans`, i.e. inTrans!=NONE).
Before the fix only a write transaction blocked DETACH.

In 3.54.1 the check is `sqlite3BtreeTxnState(pDb->pBt)!=SQLITE_TXN_NONE`
(equivalent of the new read-trans check; the old write-only check is gone).
Change: src/attach.c line 345 now tests `==SQLITE_TXN_WRITE`, restoring the
pre-fix behaviour of rejecting only write transactions. The backup check is
untouched (added later, unrelated). The btree.c/btree.h hunks only added the
helper, which has no 3.54.1 counterpart and needs no change.

## Oracle failures
test/tkt1873.test: tkt1873-1.2 (DETACH inside an active SELECT on aux) no
longer returns "database aux is locked"; DETACH proceeds and the debug build
aborts with `Assertion pTmp->pBtree!=p` in sqlite3BtreeClose, so 1.2-1.5 fail
(run crashes).
