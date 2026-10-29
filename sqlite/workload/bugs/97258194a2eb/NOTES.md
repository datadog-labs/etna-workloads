repro.sql runs the misc1-26.0 query (table abc(a,b,c) plus the nested SELECT) unchanged.
With the bug, sqlite3ExprListDup allocates an exact-size list, and a later sqlite3ExprListAppend on that list writes past the allocation. The buggy shell aborts with `free(): invalid size` (exit -6). The clean shell prints nothing and exits 0.
