repro.sql loads the dbfuzz001-100 database (page 8 has 384 bytes of unaccounted free space) via `.open --hexdb`, then runs the dbfuzz001-110 `DELETE FROM t3 WHERE x IS NOT NULL AND +rowid=6;`.
The shell's schema parser rejects the dump as given (the dump has a zeroed `index` row in sqlite_master), so I dropped that cell from page 1's cell-pointer array (cell count 6->5, pointers shifted). It is not needed for the bug.

Clean: exits 0 with no output. Buggy: the delete removes the last cell of page 8 without a rebalance (the `nCell==1` check is missing), which crashes the shell (SIGSEGV, exit status -11).
