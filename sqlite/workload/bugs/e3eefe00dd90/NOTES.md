repro.sql runs the returning1-22.1 case: with defensive mode off and writable_schema=ON,
`INSERT INTO sqlite_temp_schema DEFAULT VALUES RETURNING (SELECT * FROM xyz AS sqlite_master WHERE a=sqlite_master.name)`.

- clean: `no such column: sqlite_master.name`, exit 1.
- buggy: `lookupName: Assertion `0' failed`, abort, exit 134.

The cause is that the injection passes `pSchema` instead of `zDb` to isValidSchemaTableName(). The "sqlite_master" alias is then wrongly matched against sqlite_temp_schema.
`.dbconfig defensive off` is needed because the shell enables defensive mode and the test harness doesn't.
