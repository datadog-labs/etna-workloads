`repro.sql` creates a TEMP table with an AFTER INSERT trigger, then runs
`INSERT ... RETURNING` on it. The clean shell returns the two RETURNING rows
and the trigger fires. The buggy shell returns no RETURNING rows (the trigger
still fires), because the TEMP-table/trigger case is mishandled when
RETURNING is combined with triggers on a TEMP table.
