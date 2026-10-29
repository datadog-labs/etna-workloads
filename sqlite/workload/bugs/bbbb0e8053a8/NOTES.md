The shell has no update-hook of its own, so repro.sh compiles a tiny loadable extension (needs gcc and
sqlite3ext.h; set SQLITE_INC, default is tree/src) that calls sqlite3_update_hook() and prints each callback.
It then deletes rows from a WITHOUT ROWID table.
Clean shell: no hook output. Buggy shell: OP_Delete fires the hook (op=9 DELETE) for the WITHOUT ROWID table,
with a garbage rowid, once per deleted row.
