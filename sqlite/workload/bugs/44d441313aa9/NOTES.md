Enables double-quoted-string fallback (`.dbconfig dqs_ddl/dqs_dml on`, which the test harness has on), creates an index on the double-quoted identifier "b", then runs `ALTER TABLE t1 DROP COLUMN b`.
Clean shell: exit 1, `error in index x1 after drop column: no such column: "b" - ...`.
Buggy shell: the dangling "b" is treated as a string literal during the post-drop schema check, so the ALTER succeeds (exit 0, no error).
