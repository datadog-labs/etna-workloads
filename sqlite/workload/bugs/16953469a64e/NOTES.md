repro.sql creates a view referencing nonexistent columns, then runs ALTER TABLE ... DROP COLUMN on an unrelated table.
Clean shell: "error in view v1: no such column: d". Buggy shell: the early renameTestSchema call is missing, so the error is only the generic "SQL logic error".
