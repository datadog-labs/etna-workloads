# Rationale

Fix (ticket #3810, alternative fix) made a TEMP trigger whose table is missing
(an "orphan", after another connection drops the table) be silently ignored
during schema load: `sqlite3BeginTrigger` sets `db->init.orphanTrigger=1` and
`sqlite3InitCallback` then skips the error.

## Change
`src/trigger.c`, label `trigger_orphan_error` in `sqlite3BeginTrigger`: removed
`db->init.orphanTrigger = 1;` (replaced with `(void)0;`). This reverses the fix's
trigger.c hunk that added that assignment. With the flag never set, the check in
`sqlite3InitCallback` (src/prepare.c) never fires, so the orphan trigger's
"no such table" error is reported as a schema error again, as before the fix.
(The pre-fix `iDb==1` special case in corruptSchema no longer exists; today the
error surfaces as "malformed database schema (r1) - no such table: t1".)

## Oracle failures (test/tkt3810.test)
tkt3810-3 (got `1 {malformed database schema (r1) - no such table: t1}`, expected `0 {}`),
-4, -5, -6 and -100 fail with the same schema error.
