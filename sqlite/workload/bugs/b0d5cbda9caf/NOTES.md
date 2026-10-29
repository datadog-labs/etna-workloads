Reproducer (`repro.sql`): a contentless_delete=1 FTS5 table gets 5 rows, two of them long, which are then deleted. It then runs `bm25()`, which relies on xRowCount() and xColumnTotalSize(). The test's `fts5_test_*` functions exist only in the TCL harness, so bm25 stands in for them.

With the bug, the row count and column totals aren't updated by the deletes. The score for rowid 1 differs: clean gives -0.42408164991893577 and buggy gives -1.4906281273558495.
