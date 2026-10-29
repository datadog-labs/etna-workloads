repro.sql: creates an rtree virtual table, then does SAVEPOINT / INSERT / RELEASE.
The injected bug (vtab.c, sqlite3VtabSavepoint) forgets to dereference the module
method pointer slot, so it calls a bogus function address on RELEASE.
Clean shell prints `1|1.0|2.0` and exits 0; buggy shell segfaults (exit -11).
