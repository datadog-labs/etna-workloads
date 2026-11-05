# Rationale

Changed: src/src/bin/pg_rewind/parsexlog.c, findLastCheckpoint().
Traces to the fix_impl.patch hunk in findLastCheckpoint that calls
`keepwal_add_entry(xlogfname)` for each WAL segment opened while scanning back
to the last common checkpoint. I removed that call (the segment-change tracking
remains, but nothing is registered). The keepwal hash stays empty, so
decide_file_action() never finds a WAL file in it and returns FILE_ACTION_REMOVE
for target-only WAL segments needed for recovery from the checkpoint. This is the
original bug: critical WAL segments get deleted.

Failing oracle case:
- src/bin/pg_rewind|t/010_keep_recycled_wals.pl|some WAL files were skipped
