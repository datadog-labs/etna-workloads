Reproducer: `repro.sh`. With secure-delete on, an fts5 table gets rows and a
DELETE, then `rebuild`, then another DELETE (all in one connection). A fresh
connection then runs `PRAGMA integrity_check`.

Clean shell: prints `ok`. Buggy shell: `fts5: corruption found reading blob
137438953473 from table "t1"`. The buggy build doesn't reload the fts5 config
after rebuild/delete-all, so the second DELETE writes a corrupt index.
The reopen is needed, so this is a .sh rather than a .sql.
