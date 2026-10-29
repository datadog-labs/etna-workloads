Renames column `a` of a table referenced by a view that uses an alias in WHERE (`SELECT a AS d ... WHERE d=0`), then prints the view SQL.
Clean: `CREATE VIEW vvv AS SELECT xyz AS d FROM xxx WHERE d=0`. Buggy: the alias token `d` in the WHERE clause is also rewritten (to `xyz`), since the rename-token remap in lookupName is missing.
