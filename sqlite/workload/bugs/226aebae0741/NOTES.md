repro.sql is fts5secure8 test 1.x: a table with a 64-byte page size has a long (500x "hello world ") position list
written in a transaction, then secure-delete is enabled and that row is deleted.
The buggy shell hits the assertion `enc!=0 || n>=0` in sqlite3VdbeMemSetStr and aborts (exit -6).
The clean shell prints `ok` from integrity_check and exits 0.
