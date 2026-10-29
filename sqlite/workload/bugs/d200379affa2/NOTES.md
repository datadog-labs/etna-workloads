repro.sql creates a table whose last column `c` is preceded by a comment containing a comma, drops `c`, and prints the schema SQL.
Clean shell: the drop succeeds and the schema is `CREATE TABLE t1(a INT, b INT)`, exit 0.
Buggy shell: the drop scans backwards for ',' and stops at the comma inside the comment. The rewritten SQL is invalid, so it fails with "error in table t1 after drop column: incomplete input", exit 1, and the schema is unchanged.
