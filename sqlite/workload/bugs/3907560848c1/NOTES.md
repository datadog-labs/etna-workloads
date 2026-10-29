repro.sql builds the fkey1-8.2/8.3 corrupt schema (a WITHOUT ROWID sqlite_stat1 whose
autoindex entry is renamed via writable_schema; `.dbconfig defensive off` is needed in the shell)
and runs REINDEX.
Clean: "Error near line 8: database disk image is malformed", exit 1.
Buggy: assertion `pPk->tnum==pTab->tnum' failed in sqlite3OpenTable, abort (exit 134).
