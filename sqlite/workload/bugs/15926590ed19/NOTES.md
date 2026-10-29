repro.sh creates a database with page_size=512, then overwrites the header page-size field (offset 16) with 256 and queries it (filefmt-1.7).
Clean: "file is not a database" error. Buggy: the page-size lower bound check is missing, so 256 is accepted and an assertion fails in sqlite3PagerSetPagesize (abort, exit 134).
