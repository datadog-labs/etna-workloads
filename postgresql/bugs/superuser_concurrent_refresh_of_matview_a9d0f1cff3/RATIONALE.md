# Rationale

All changes are in `src/backend/commands/matview.c`. They reverse fix_impl.patch (adapted to current code, where the functions are `RefreshMatViewByOid`, `refresh_matview_datafill`, `refresh_by_match_merge`).

The fix made the whole refresh run as the matview owner, including creation of the temp/diff tables. The bug is that only the data-fill and the final DELETE/INSERT ran as the owner. The temp tables are then created as the invoking superuser and the owner cannot access them.

- `RefreshMatViewByOid`: removes the early GetUserIdAndSecContext/SetUserIdAndSecContext/NewGUCNestLevel block and the final GUC rollback and userid restore. This is the fix hunk that added them to ExecRefreshMatView. The `save_*` locals are removed, and `relowner` is passed to `refresh_matview_datafill` and `refresh_by_match_merge` as in the old signatures.
- `refresh_matview_datafill`: gets back the owner switch (userid, SRO, GUC nest level, search path) and its restore. This is the hunk that removed them from datafill.
- `refresh_by_match_merge`: removes the LOCAL_USERID_CHANGE and SRO switches around the diff-table creation. It restores the owner switch only around the DELETE/INSERT, as in the pre-fix code. The signature loses `save_sec_context`.

The diff table is now created by the invoking superuser, and the later DELETE/INSERT as the owner fails with a permission error.

Failing oracle case: `src/test/regress||matview`
