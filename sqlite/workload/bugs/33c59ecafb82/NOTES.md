Reproducer (`repro.sql`) is misc1-23.2: with defensive mode off, it corrupts the schema so the stored SQL of
both entries is `CREATE TABLE IF not EXISTS t(c)`. It then rolls back a transaction, which forces a schema reload.
The reload hits sqlite3StartTable with init.busy set and the table already existing.
Clean shell: `Parse error near line 8: no such table: F`, exit 1.
Buggy shell: assertion `!db->init.busy` fails in sqlite3StartTable and the shell aborts (exit -6).
