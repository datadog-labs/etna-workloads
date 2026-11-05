# Rationale

## src/backend/partitioning/partdesc.c, RelationGetPartitionDesc()
Traces to the partdesc.c hunk of fix.patch that changed the relcache-use condition. The fix made
the relcache descriptor usable only when `!detached_exist || !omit_detached`, so that a
snapshot-dependent "omit detached" request never gets a cached descriptor that includes a
partition pending detach. The current code has evolved: it also has a `!ActiveSnapshotSet()` clause
and an rd_partdesc_nodetached cache keyed by xmin.

The change makes the function return `rel->rd_partdesc` whenever it exists, whatever `omit_detached` is.
A cached descriptor that includes the detached partition is then handed to omit-detached callers
such as RI queries in REPEATABLE READ. The detached partition is not omitted, which is the original bug.

## Failing oracle cases
- src/test/isolation||detach-partition-concurrently-4
