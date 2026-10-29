Creates a table, turns on the shell's authorizer (`.auth ON`), then runs `ALTER TABLE t2 DROP COLUMN c`.
The fix makes dropColumnFunc clear db->xAuth while it parses the schema SQL.
Clean shell: the ALTER succeeds, and the authorizer trace is printed, ending with exit status 0.
Buggy shell: the authorizer is still active during the rename-parse, so it aborts with
`realAuthCheck: Assertion '!IN_RENAME_OBJECT || db->xAuth==0' failed` (exit status 134).
