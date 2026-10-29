repro.sh: sets a 1 MiB file chunk size (`.filectrl chunk_size`), grows the db file with a 900 KB
zeroblob and deletes it (file stays large, dbSize is larger than the valid page count),
then runs `PRAGMA max_page_count = 100`.
Clean shell prints 905/905 and exits 0. Buggy shell hits the assertion
`pPager->mxPgno>=pPager->dbSize` in sqlite3PagerMaxPageCount and aborts (exit 134).
