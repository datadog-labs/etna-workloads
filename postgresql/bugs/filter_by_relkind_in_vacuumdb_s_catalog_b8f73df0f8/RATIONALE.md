# Rationale

## src/bin/scripts/vacuumdb.c, function vacuum_one_database
Traces to the single hunk of fix.patch (vacuumdb.c). The fix guarded the
`c.relkind = ANY(array[RELKIND_RELATION, RELKIND_MATVIEW])` filter with
`if (!tables_listed)`; in current code the guard is `(objfilter & OBJFILTER_TABLE) == 0`.
I removed the guard so the relkind filter is always applied, even with --table.
Views named via --table are then silently skipped instead of being sent to the
server, which would emit the "cannot vacuum non-tables" warning.

## Failing oracle cases (2/105)
- src/bin/scripts|t/100_vacuumdb.pl|vacuumdb with view stderr /(?^s:^WARNING.*cannot vacuum non-tables or special system tables)/
- one more case (2 failures in total) in the same test; see logs/oracle.log.
