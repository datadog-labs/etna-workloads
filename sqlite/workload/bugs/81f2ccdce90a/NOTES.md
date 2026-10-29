repro.sql turns on the shell authorizer (`.auth ON --deny "ALTER_TABLE*"`) and runs
`ALTER TABLE t5 ADD COLUMN c2`. Clean: the authorizer is invoked for ALTER_TABLE and
denies it ("not authorized"), schema unchanged. Buggy: the ADD COLUMN path never calls
the authorizer, so the column is added despite the deny.
