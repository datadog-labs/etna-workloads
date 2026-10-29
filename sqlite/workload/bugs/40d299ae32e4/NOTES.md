Reproducer: `repro.sql` creates an FTS5 table in a UTF-16le database and inserts a blob
(x'2a12') bound as a parameter via `.parameter set`, which uses sqlite3_bind_blob (UTF-8 encoding tag).
Then it runs the FTS5 `integrity-check`.

Clean shell: integrity-check succeeds, no output besides `X'2A12'`, exit 0.
Buggy shell: integrity-check fails with "database disk image is malformed", exit 1.
(Bound blob is tokenized with the wrong encoding, so the index doesn't match content.)
