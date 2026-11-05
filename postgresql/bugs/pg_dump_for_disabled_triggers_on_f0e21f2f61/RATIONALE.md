# Rationale

## src/bin/pg_dump/pg_dump.c, getTriggers (PG15+ query)
Traces to the fix.patch getTriggers hunk that added `OR t.tgenabled != u.tgenabled` so tgisinternal
partition triggers are fetched when their tgenabled differs from the parent's. In today's code that
condition is in the >=150000 query as `((NOT t.tgisinternal AND t.tgparentid = 0) OR t.tgenabled != u.tgenabled)`.
I reduced it to `NOT t.tgisinternal AND t.tgparentid = 0`. pg_dump therefore never sees partition
triggers with a changed tgenabled, so disabled/replica triggers on partitions are not dumped
(no ALTER ... TRIGGER emitted).

## Failing oracle cases
Many cases in src/bin/pg_dump|t/002_pg_dump.pl fail (10075/13810 overall, mostly 'missing' because the
TAP script aborts), including "Replica trigger on partition is altered" and
"Triggers on partitions are not dropped" for each run mode.
