repro.sql: with foreign keys on, an rtree table's xDestroy() fails partway
(dropping shadow table rt_rowid violates an FK from `child`) inside an open
transaction. The fix makes DROP TABLE on a virtual table use a statement
journal (sqlite3MayAbort), so the partial drop is rolled back.

Clean: error, sqlite_master still lists rt, rt_node, rt_parent, rt_rowid, child;
`SELECT * FROM rt` returns the row.
Buggy: rt_node and rt are gone from sqlite_master (partial drop persists), and
`SELECT * FROM rt` fails with "database disk image is malformed".
