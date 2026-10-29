The shell has no incremental-blob command, but the R-Tree module reads its
`%_node` table through `sqlite3_blob_open()` and keeps that handle open between
statements. `repro.sql` builds a 3000-row rtree (page_size=1024), runs a query
to leave a blob cursor open, then runs `DELETE ... WHERE id%2=0`.

Clean: the DELETE succeeds and `count(*)` is 1500.
Buggy: the DELETE fails with "database disk image is malformed" (exit status 1)
and `count(*)` is still 3000. The invalidated blob cursor keeps its page
references, which btree.c takes as a sign of corruption.
