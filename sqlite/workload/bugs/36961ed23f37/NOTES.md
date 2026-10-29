Reproducer: repro.sql. Builds an FTS3 table with multi-block segments, then (defensive off, writable_schema)
turns the `t_segments` shadow table into a VIEW over a copy table. FTS3 then calls sqlite3_blob_open() on it.

Clean: blob_open rejects the view ("cannot open view"), so the query fails with "database disk image is malformed" (rc=1).
Buggy: the view/virtual-table checks are gone, so blob_open proceeds on a view and hits
`sqlite3ColumnIndex: Assertion i<nCol failed` (abort, rc=134).
