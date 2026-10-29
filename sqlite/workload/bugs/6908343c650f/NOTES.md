Reproducer: `repro.sql`. The shell's `.import` reuses one prepared INSERT statement for every row, calling sqlite3_reset() between rows. That matches the reuse in fkey2-19.
Row `3` violates the immediate FK constraint and the insert fails. Row `1` is valid.
Clean shell: only row 3 is rejected, and `SELECT` returns `1`.
Buggy shell: the reset doesn't zero `nFkConstraint`, so the stale count makes the valid row fail too. The shell then hits an assertion failure (abort, exit -6) and prints constraint errors.
