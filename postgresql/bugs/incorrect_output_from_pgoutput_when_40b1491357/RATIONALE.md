# Rationale

The fix made pgoutput apply the publication column list to the old tuple/key
in UPDATE and DELETE messages. I reverted that, so old tuples are written
with all columns.

## Hunks

1. `src/backend/replication/logical/proto.c`, `logicalrep_write_update()`:
   the old-tuple `logicalrep_write_tuple()` call passes `NULL` instead of
   `columns`. This traces to the first proto.c hunk of fix.patch.
2. `src/backend/replication/logical/proto.c`, `logicalrep_write_delete()`:
   the `logicalrep_write_tuple()` call passes `NULL` instead of `columns`.
   This traces to the second proto.c hunk of fix.patch (the same call).
   The `columns` parameter and the pgoutput.c callers are left in place. They
   are now unused by this function, which keeps the diff minimal.

## Effect

Old key/old tuple messages include columns outside the column list. The
subscriber then sees columns that should not be replicated, or fails on
columns that don't exist on its side.

## Failing oracle cases

All 36 cases in src/test/subscription t/031_column_list.pl report FAIL
('missing'). The script aborts early on the first failure, so later cases
never run. They include, for example:
- all columns should be replicated (and #2)
- check the number of columns in the old tuple
- different column lists detected
- initial synchronization with multiple publications with the same column list
- insert on column tab1.c is not replicated (and #2)
- insert on column tab2.c is not replicated
