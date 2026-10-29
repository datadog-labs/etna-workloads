Creates a trigger containing `UPDATE ... FROM t2, t3`, then renames t3 to t5.
Clean shell rewrites the trigger to `FROM t2, "t5"`; the buggy shell fails to
rename the table reference in the trigger's UPDATE FROM clause (or asserts).
