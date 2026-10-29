repro.sql: creates an external-content fts5 table, then issues a 'delete' command for a row that was never indexed.
Clean shell: "database disk image is malformed" (exit 1), since the total row count would go negative.
Buggy shell: the check is removed, so the statement succeeds silently (exit 0) and the index is corrupted.
