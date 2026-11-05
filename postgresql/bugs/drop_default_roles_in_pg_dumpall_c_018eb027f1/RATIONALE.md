# Rationale

## src/bin/pg_dump/pg_dumpall.c, dropRoles()
Traces to the fix.patch hunk in dropRoles(): the `server_version >= 90600` branch with
`WHERE rolname !~ '^pg_'`. Today's code builds the query via printfPQExpBuffer with `role_catalog`;
I removed the 9.6+ branch so the query always selects every role. `pg_dumpall -c` therefore
emits `DROP ROLE pg_...` for the predefined (default) roles again.

## Failing oracle cases
The oracle run reported 10039/13808 failing, mostly in src/bin/pg_dump|t/002_pg_dump.pl
(e.g. the `test_schema_plus_large_objects: should not dump ...` cases). I only looked at the tail
of the output, so I haven't confirmed that all of these failures come from this change.
Full list: logs/oracle.log.
