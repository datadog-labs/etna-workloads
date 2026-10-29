Reproducer: repro.sql. Creates a table and an index, runs a SELECT that uses the index
(this lazily builds the index's zColAff string), then drops the table, which frees the index.

The injected bug allocates zColAff from the connection's lookaside buffer but frees it with
sqlite3_free() instead of sqlite3DbFree(). The clean shell exits 0 with no output. The buggy
shell aborts (status 134) with `sqlite3StatusDown: Assertion `N>=0' failed.`

This is not the shared-cache scenario from shared2.test. A single connection hits the same
alloc/free mismatch.
