repro.sql creates a view whose CTE `g` references another CTE `p` and then renames the underlying table.
Clean shell: the rename succeeds and the view SQL now refers to "t2".
Buggy shell: `ALTER TABLE ... RENAME` fails with "error in view v0 after rename: no such table: main.t1", and the view is left unchanged.
