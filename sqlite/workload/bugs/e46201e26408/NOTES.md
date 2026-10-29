repro.sql builds a WITHOUT ROWID table t2 with a self-referencing foreign key (b,c) -> t2(d,e). Row 1 is its own parent, and row 2 also uses row 1 as its parent. It then deletes row 1.

- Clean shell: `DELETE` fails with "FOREIGN KEY constraint failed" (exit 1), because row 2 still references row 1.
- Buggy shell: `DELETE` succeeds (exit 0), a wrong result. The self-reference check compares the wrong key columns, so row 2 is not counted as a child.
