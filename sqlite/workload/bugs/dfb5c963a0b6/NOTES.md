`repro.sql` creates a trigger with a vector assignment `UPDATE t1 SET (c,d)=(a,b)`, then renames the table, column a, and column d.
Clean: all renames succeed and the trigger SQL shows `new.aaa` and `(c,ddd)=(aaa,b)`, exit 0.
Buggy: the `RENAME a TO aaa` fails with "error in trigger r1 after rename: no such column: a", because the vector-assignment expressions lose their rename-token mapping. The trigger keeps `new.a` and `(a,b)`, and the exit status is 1.
