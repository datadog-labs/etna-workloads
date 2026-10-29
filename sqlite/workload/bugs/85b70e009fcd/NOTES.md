Creates a table and enables the shell's `.auth ON` authorizer tracer, then runs `ALTER TABLE t5 DROP COLUMN b`.
Clean shell: the trace starts with `authorizer: ALTER_TABLE 'main' 't5' 'b' NULL -> OK`.
Buggy shell: DROP COLUMN never calls the authorizer, so that line is missing. This is the same check auth-1.302-drop-2 makes.
