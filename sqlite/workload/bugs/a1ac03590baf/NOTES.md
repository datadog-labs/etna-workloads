Creates a trigger whose WINDOW definition references a nonexistent table, then runs ALTER TABLE RENAME.
Clean shell reports "error in trigger b: no such table"; the buggy shell hits assert(rc==WRC_Continue) in walker.c (sqlite3WalkSelectExpr) and aborts.
