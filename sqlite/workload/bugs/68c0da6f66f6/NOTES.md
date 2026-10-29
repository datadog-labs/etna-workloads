Reproducer (repro.sql): fts5 table with detail=none, secure-delete=1, pgsz=64; insert 500 rows
with the same token, delete rows in two bulk batches, then run integrity-check.
Clean shell: no output, exit 0. Buggy shell: "database disk image is malformed" (exit 1),
because fts5SegIterNext_None advances only one page (`if` instead of `while`) when
skipping over empty leaf pages left by secure-delete.
