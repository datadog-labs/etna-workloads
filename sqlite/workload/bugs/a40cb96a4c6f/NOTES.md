repro.sql runs the rowid-15.1 query: a `rowid <= 'a'` seek OR'd with another term, with
reverse_unordered_selects on. The buggy shell fails assert `pC->deferredMoveto==0` in
sqlite3VdbeExec (abort, status -6); the clean shell returns rows `1|` and `1|0`.
