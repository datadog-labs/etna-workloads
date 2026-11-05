# Rationale

## Change
File: `src/backend/replication/pgoutput/pgoutput.c`, function `get_rel_sync_entry()`.

Traces to the fix.patch hunk in `rel_sync_cache_publication_cb()`, which reset
`entry->pubactions.{pubinsert,pubupdate,pubdelete,pubtruncate}` to false when a
publication changed, so that tables dropped from a publication stop being replicated.

In current code that reset lives in `get_rel_sync_entry()`, in the block that
rebuilds an invalid entry ("Also reset pubactions to empty in case rel was dropped
from a publication"). I removed those four assignments. The cache callback only sets
`replicate_valid = false`, so the stale pubactions survive revalidation.

## Why it brings back the bug
Pubactions are only OR-ed in for publications that still contain the table. After
ALTER PUBLICATION ... DROP TABLE, the old flags are never cleared, so changes for
the dropped table keep being published.

## Failing oracle cases (t/001_rep_changes.pl)
- check rows on subscriber after table drop from publication
- check replicated inserts after subscription publication change
- check replicated deletes after alter publication
