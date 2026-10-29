repro.sql builds a 5000-row fts5 table (detail=none, 4096 page size), runs 'optimize' and
enables secure-delete, then overwrites the first 2 bytes (first-rowid offset) of a leaf
page in t_data with 0xFFFF and deletes rowid 4500.

Clean: `Error near line 13: fts5: corruption in table "t"`, exit status 1.
Buggy: the missing `iStart>nPg` check lets fts5DoSecureDelete read past the page, so the
corruption is not detected and the DELETE succeeds silently (exit 0).
