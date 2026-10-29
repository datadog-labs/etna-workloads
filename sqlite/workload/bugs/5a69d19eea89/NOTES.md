repro.sql creates a trigger whose UPDATE has a vector SET `(k,v) = ((WITH ... SELECT ... FROM t2), 1)`, then runs `ALTER TABLE t2 RENAME TO t2x`.

Clean shell: the rename succeeds and the trigger SQL refers to "t2x".
Buggy shell: the rename fails with "error in trigger r2 after rename: no such table: t2", exit status 1.
