# Rationale

Fix hunks reversed, all in `src/alter.c` (the `build.c` hunk was left alone, since `addColOffset` is already set outside the init.busy block in 3.54.1 and the live table's value is what gets passed):

- `sqlite_drop_column` takes 4 args again (registration 3 -> 4, `sqlite3AlterDropColumn` passes `pTab->u.tab.addColOffset` of the live table, `dropColumnFunc` reads `argv[3]` as `iAddColOffset`, doc comment restored). This reverses the fix hunks that removed argv[3]. `zEnd` uses `&zSql[iAddColOffset]` again instead of the offset from the freshly reparsed table.
- Removed `pTab->nCol==1` from the corruption check in `dropColumnFunc` (the fix added it). With a corrupt schema that reparses to a single column, the last-column branch runs with `iCol==0`.

Failing oracle case: `altercorrupt-2.1` aborts on `assert(iCol!=0)` in `dropColumnFunc` instead of returning "database disk image is malformed". The other oracle cases still pass.
