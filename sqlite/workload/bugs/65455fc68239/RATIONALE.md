# Rationale

The fix replaced `LIKE 'sqlite_%'` (where `_` is a wildcard, so tables named e.g. `sqlite1234` were skipped) with `LIKE 'sqliteX_%' ESCAPE 'X'`. In 3.54.1 these still exist in `src/alter.c`; I reverted the five that correspond to the fix's hunks:

- `renameTestSchema` (main db and temp queries): back to `name NOT LIKE 'sqlite_%'`.
- `sqlite3AlterRenameTable`, first UPDATE (`sqlite_rename_table`): back to `name NOT LIKE 'sqlite_%'`.
- `sqlite3AlterRenameTable`, second UPDATE: autoindex test back to `name LIKE 'sqlite_autoindex%'` (no ESCAPE).
- `sqlite3AlterRenameColumn`: back to `name NOT LIKE 'sqlite_%'`.

I left the two newer `sqliteX_` clauses (alter.c lines 94 and 101, in `renameTestSchema`'s sibling code) unchanged because the fix doesn't touch them.

Oracle: `altertab-17.0` fails. The table `sqlite1234` is treated as an internal sqlite_ table, so its schema SQL isn't rewritten on rename to `User`.
