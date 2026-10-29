Reproducer (repro.sql): builds an FTS3 table, turns off defensive mode, and writes crafted rows into the shadow tables f_segdir, f_segments and f_stat. It then runs `INSERT INTO f(f) VALUES('merge=1')`. This is test fts3corrupt-6.10.

Clean shell: `Error near line 10: database disk image is malformed`, exit status 1.
Buggy shell: segfault (exit status -11). fts3IncrmergeLoad() uses a NULL aRoot blob without checking it.
