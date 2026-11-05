# Rationale

Hunk: src/backend/commands/tablecmds.c, `transformColumnNameList()`. It traces to the fix.patch hunk that adds the `attform->attnum < 0` check.

I removed the check that raised "system columns cannot be used in foreign keys". Foreign keys on system columns such as `ctid` or `xmin` are accepted again, so the tests that expect the error no longer see it.

I left out the comment and the `attform` refactor from the fix. Neither affects behaviour. The `attform` variable is still used for the remaining assignments.

Failing oracle case: src/test/regress||foreign_key
