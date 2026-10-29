repro.sql creates an FTS4 table with `prefix=0` and inserts one row (test fts3prefix-6.1.1).

- clean: the zero-size prefix is ignored, the INSERT works, and `count(*)` on `t1_segdir` prints 1. Exit status is 0.
- buggy: the zero-size prefix index is kept, so the INSERT fails with "out of memory". `count(*)` prints 0. Exit status is 1.

I couldn't run `./check.sh` because bwrap failed inside the sandbox. I ran both shells by hand instead.
