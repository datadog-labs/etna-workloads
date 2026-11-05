# Rationale

Reverts the fix for CREATE TABLE IF NOT EXISTS AS EXECUTE.

1. `src/backend/parser/gram.y`, rule `ExecuteStmt`: traces to the gram.y hunk in fix.patch.
   - Removed the `CREATE OptTemp TABLE IF_P NOT EXISTS create_as_target AS EXECUTE ...` alternative.
   - Removed the `ctas->if_not_exists = false;` line from the plain alternative.
   Without the new alternative, `CREATE TABLE IF NOT EXISTS t AS EXECUTE ...` is a syntax error.

2. `src/interfaces/ecpg/preproc/ecpg.addons` and `parse.pl`: these entries only existed
   for the removed grammar alternative (today's code has them, the original fix did not need them).
   They were removed so ecpg still builds, because parse.pl errors on an unused replace_line entry.
   This is a build adaptation, not a separate bug.

Failing oracle case: `src/test/regress||create_table`
