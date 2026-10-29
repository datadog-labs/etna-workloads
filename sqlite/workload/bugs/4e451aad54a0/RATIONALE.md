# Rationale

The fix moved the "orphan trigger" handling (`db->init.orphanTrigger = 1` when
`db->init.iDb==1`) into a new `trigger_orphan_error` label in
`sqlite3BeginTrigger()` (src/trigger.c). The error paths for virtual tables,
BEFORE/AFTER triggers on views, and INSTEAD OF triggers on tables were changed
to jump to it. Before the fix, only the `!pTab` path set the flag.

In 3.54.1 the label already exists, so I reverted those three jumps
(virtual table, trigger on view, INSTEAD OF on table) back to
`goto trigger_cleanup`. The `!pTab` path and the shadow-table check, which was
added after the fix, still use the label.

With the jumps reverted, a TEMP trigger on an aux-database table is no longer
treated as orphaned when the name later resolves to a view. This is the
pre-fix behaviour.

## Oracle
`tkt3810-100` fails with
`malformed database schema (r1) - cannot create BEFORE trigger on view: t1`.
The other tkt3810 cases pass.
