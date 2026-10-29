`repro.sql` turns off defensive mode and writable_schema, then runs
`INSERT INTO sqlite_schema DEFAULT VALUES RETURNING sqlite_schema.name` (and the
temp-schema equivalent). The alias `sqlite_schema` differs from the real table
name `sqlite_master`, which the fix accepts via isValidSchemaTableName().

Clean shell: exit 0, prints empty rows. Buggy shell: assertion failure in
lookupName (`Assertion '0' failed`), exit status -6 (SIGABRT).
