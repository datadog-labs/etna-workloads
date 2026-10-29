repro.sql creates a table with `PRIMARY KEY(c1 collate rtrim)` on an INTEGER column plus a UNIQUE constraint, then runs `ALTER TABLE ... RENAME c1 TO c3`.
Clean shell: rename succeeds and the schema shows c3. Buggy shell: assertion failure in renameTokenCheckAll (`p->p!=pPtr`), exit status -6 (abort).
The injection removes sqlite3ExprSkipCollate in sqlite3AddPrimaryKey, so the rename token is remapped to the COLLATE wrapper expr, which is later freed (dangling pointer).
