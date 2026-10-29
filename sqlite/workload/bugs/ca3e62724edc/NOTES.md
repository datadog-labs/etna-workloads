repro.sql: fts5 table with detail='none' and secure-delete on; in one transaction delete rowid 1,
re-insert rowid 1 and insert rowid 2, all with token 'a'.
Clean: MATCH 'a' returns 1 and 2; integrity-check passes.
Buggy: MATCH returns only 1, and integrity-check fails with "checksum mismatch" (exit status 1).
