Reproducer (`repro.sql`): creates an fts5 table with two rows and runs the
query `SELECT rowid FROM f1('"" a')`. The phrase `""` has zero tokens, and
the query joins it to `a` by implicit AND.

Clean shell: returns rows 1 and 2. The fix makes `sqlite3Fts5ParseImplicitAnd`
drop the empty phrase from an implicit AND.
Buggy shell: returns no rows, because the injection builds a plain AND node
with the empty phrase. Exit status is 0 in both shells.

`fts5_expr()` is only registered in the TCL test build, so fts5eb-1.2 and
fts5eb-1.11 can't be reproduced in the shell. fts5fuzz1-2.2.3 is the
reproducible case.
