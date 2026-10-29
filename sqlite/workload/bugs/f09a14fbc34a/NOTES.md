Reproducer (repro.sql) is the gencol1-4.100/4.110 case: a table with a virtual generated column
(c1) before a column (c3) that has a foreign key to the generated column, then a REPLACE that
deletes the conflicting row.
Clean shell: "FOREIGN KEY constraint failed" (exit 1).
Buggy shell: assertion failure `memIsValid(&aMem[pOp->p1])` in sqlite3VdbeExec (abort), because the
FK/delete code uses iCol rather than the storage-column index for register offsets.
