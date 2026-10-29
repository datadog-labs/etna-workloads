Reproducer for the fts5 'optimize' bug (fts5simple-20.2). repro.sql builds an fts5 table
with pgsz=32, inserts 200 rows one per transaction, optimizes, deletes a row, optimizes
again, then runs integrity-check. The buggy shell reports a corrupt index on the
integrity-check (clean prints nothing).
