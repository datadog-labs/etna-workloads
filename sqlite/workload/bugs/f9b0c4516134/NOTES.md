Creates a WITHOUT ROWID table with an INTEGER PRIMARY KEY column and renames that column.
Clean shell: rename succeeds and sqlite_master shows `PRIMARY KEY(c1)`.
Buggy shell: the rename fails with "error in table t0 after rename: no such column: c0" (exit 1) and the SQL is unchanged.
