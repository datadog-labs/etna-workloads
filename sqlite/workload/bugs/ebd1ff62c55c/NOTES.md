repro.sql ports vtabK-200..220: a virtual table named sqlite_stat1 (fts5) is created with
defensive mode off (the shell is defensive by default, so `.dbconfig defensive off` is needed
for writable_schema to take effect), then `CREATE VIRTUAL TABLE ... rtree` forces a schema reload.

Clean: "no such column: stat" for the rtree create, then the SELECT returns Ebed-malech (exit 1).
Buggy: same error, then assertion failure `p==pOld` in sqlite3EndTable and abort (exit -6),
because the stat1 load runs sqlite3_declare_vtab with db->init.busy set.
