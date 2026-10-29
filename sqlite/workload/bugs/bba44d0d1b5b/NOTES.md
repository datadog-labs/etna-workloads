Reproducer (repro.sql): FTS4 table, REPLACE inserts and then `UPDATE OR REPLACE ... SET docid=2` that overwrites an existing row (fts3conf-3.1 to 3.4).
When the replaced row is the last one, the buggy build doesn't reset the pending doc-size deltas (aSzDel) and decrements the doc count instead of zeroing it.
Clean: prints X'0100000006000000'. Buggy: "database disk image is malformed", exit status 1.
