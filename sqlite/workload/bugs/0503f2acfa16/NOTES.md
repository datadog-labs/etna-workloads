repro.sql joins sqlite_dbpage (a nested-loop inner scan) against a table, so dbpageFilter runs
repeatedly on the same cursor. The injection removes the unref of the previous pPage1, leaking a pager ref.
Clean: prints `1|main|SQLite`, exit 0.
Buggy: assertion failure `sqlite3PagerRefcount(pBt->pPager)==1` in unlockBtreeIfUnused, abort (exit -6).
