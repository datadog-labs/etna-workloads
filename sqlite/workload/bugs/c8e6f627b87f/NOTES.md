Reproducer: `SELECT * FROM generate_series(0,0,0);` (repro.sql).
Clean shell: step 0 is treated as 1, prints one row `0`.
Buggy shell: the explicit zero step is not normalized, so the shell aborts (core dump, assertion failure).
