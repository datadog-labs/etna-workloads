The shell can't interleave statements, so misc2-7.12 (delete each row while scanning `ORDER BY rowid DESC`) is emulated in one statement. `INSERT OR REPLACE INTO log SELECT rowid FROM t1 ORDER BY rowid DESC` scans t1 directly with Prev. With recursive_triggers on, each replaced `log` row fires an AFTER DELETE trigger that deletes the matching t1 row.
When the last row goes, the scan cursor's restore finds an empty table (CURSOR_INVALID) with a stale skipNext<0.
Clean: returns SQLITE_DONE and the statement finishes (log = 1,2,3; t1 empty).
Buggy: btreePrevious returns SQLITE_OK on the invalid cursor, so the loop never ends and the shell hangs (check.sh reports a timeout).
