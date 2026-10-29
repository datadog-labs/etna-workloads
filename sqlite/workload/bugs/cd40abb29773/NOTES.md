`repro.sql` creates a table with a 5-column PRIMARY KEY and runs a SELECT that has an equality term on every key column.

The planner's whereShortCut() code in the buggy shell no longer skips unique indexes with more than 4 columns. It writes past the 4-entry `aLTermSpace` array.

Clean shell: exits 0 with no output. Buggy shell: crashes with SIGSEGV (exit status -11).

The OOM part of the upstream test (case 3) needs simulated malloc failures, which the shell can't do. The crash is already visible without that.
