# Rationale

Fix hunk reversed: `renameColumnFunc` in src/alter.c. The fix replaced the
local `int bTemp = 0;` with a value read from a new 9th argument, so that
statements from the temp schema are parsed as temp (letting a temp trigger
reference tables in other attached databases). In 3.54.1 the argument is still
passed by both callers (iSchema==1 / 1), so I restored the pre-fix behaviour in
the function itself: `int bTemp = 0;` (argument 8 ignored). This is equivalent
to the old code, where bTemp was always 0 in renameColumnFunc.

Other fix hunks (sqlite_rename_table `else` branch, releaseMemArray testcase,
error message change) are not part of this bug.

Oracle failure: altercol-18.1 (`ALTER TABLE t1 RENAME a TO b` with a TEMP
trigger inserting into `aux.log` via unqualified `log`) fails, since the temp
trigger is re-parsed as non-temp and the lookup of `log` fails.
