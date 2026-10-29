# Rationale

## Change: `tree/src/pager.c`, `sqlite3PagerMovepage()`

The fix added a block at the top of `sqlite3PagerMovepage()`. If the page being moved is dirty and the latest savepoint has not saved it, the block writes the page to the sub-journal. In 3.54.1 that block is spelled `if( (pPg->flags & PGHDR_DIRTY)!=0 && SQLITE_OK!=(rc = subjournalPageIfRequired(pPg)) ) return rc;`. `subjournalPageIfRequired()` is the modern form of the original `subjRequiresPage(pPg) && subjournalPage(pPg)`. I removed this block, which restores the pre-fix code.

The fix's other hunk moved `int rc;` to function scope. 3.54.1 already declares `rc` there, and removing the block leaves it in use, so that hunk needs no change.

## Oracle
`./check.sh` reports 3 failures out of 140: savepoint-11.10, 11.11 and 11.12. These are the tests the fix added. In 11.10, `DROP TABLE t1` moves a page inside a savepoint on an auto-vacuum database, and then `ROLLBACK TO two` runs. Without the sub-journal write, the moved page's contents are not restored, so `t2` is not returned intact. The failures in 11.11 and 11.12 follow from 11.10.
