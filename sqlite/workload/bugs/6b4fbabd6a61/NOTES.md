Reproducer (`repro.sql`) is a direct SQL translation of fts5delete-1.0..1.2: builds a 5000-row fts5 table,
then in one transaction inserts odd values and deletes even rowids, then runs `usermerge`/`merge` followed
by `integrity-check` five times.

Clean shell: no output, exit 0. Buggy shell: each integrity-check fails with
`fts5: checksum mismatch for table "t1"` (exit status 1), since the merge saved state mid-term and corrupted the index.
