Reproducer: repro.sh (wal-19.* from wal.test).
Connection 2 reads a WAL db (stale wal-index header) and stays open; connection 1 inserts (5,6) and closes; connection 2 closes last, checkpointing and deleting the WAL.
Clean: final SELECT returns 1|2, 3|4, 5|6. Buggy: close checkpoints the stale snapshot, so the row 5|6 is lost (1|2, 3|4 only).
