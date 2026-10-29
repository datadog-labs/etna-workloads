# Rationale

## Changed hunk: src/delete.c, sqlite3GenerateRowDelete()

Fix hunk: wrapped `sqlite3VdbeAppendP4(v, pTab, P4_TABLE)` for OP_Delete in `if( pParse->nested==0 )`,
so nested statements (e.g. the DELETE FROM sqlite_master run by DROP TABLE) don't attach the
table to OP_Delete and thus don't fire the pre-update hook.

In 3.54.1 the condition had grown to `pParse->nested==0 || sqlite_stat1`. I restored the pre-fix
code: the P4_TABLE is appended unconditionally. (This also drops the later sqlite_stat1 exception,
which is only meaningful as part of that same condition.)

## Oracle
test/hook.test `hook-8.6` (`DROP TABLE y1` must produce no preupdate callbacks) fails: the
pre-update hook is invoked for the sqlite_master row deleted by DROP TABLE. Other cases pass.
