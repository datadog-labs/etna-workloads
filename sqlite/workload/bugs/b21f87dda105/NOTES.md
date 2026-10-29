`repro.sql` builds an FTS4 external-content table, rebuilds the index, then deletes the content row and calls `snippet()`. FTS4 fetches the content row with a statement that finds no row, then calls `sqlite3_column_text()` on it. That is the misuse the fix guards against (column access with no current result row).

- clean: `snippet()` returns an empty/NULL result and the shell exits normally.
- buggy: `columnMem` indexes through a NULL `pResultRow` and the shell segfaults (exit 139).
