Reproducer: a one-row INTEGER PRIMARY KEY table queried with `x < 'a' ORDER BY rowid DESC` (and `<=`).
This makes OP_SeekLT/OP_SeekLE seek with a non-numeric text key.
Clean shell returns row 100 for each query. The buggy shell returns no rows, because the seek jumps to P2 instead of moving to the last entry.
