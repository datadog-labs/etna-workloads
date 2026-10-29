Creates a table with a CHECK constraint named `a"b`, then runs `ALTER TABLE ... DROP CONSTRAINT "a""b"`.
Clean shell drops the constraint (schema shows `CREATE TABLE t1(a, b)`); the buggy shell mis-dequotes the name (passes the raw/partly-dequoted token to %Q) and fails to find the constraint, giving an error.
