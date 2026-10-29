Table with rows (1,5),(2,NULL); `SELECT p, max(q)` / `min(q)` should return the bare column p from the row holding the max/min (1).
The injection returns early on NULL args, skipping sqlite3SkipAccumulatorLoad, so p is taken from the NULL row (2) in the buggy shell.
