# Rationale
Reverted the relcache-invalidation fix at the two sites; helper functions are left in place (still used elsewhere).

- `src/backend/catalog/pg_publication.c`, `publication_add_relation()`: traces to the fix.patch hunk replacing `CacheInvalidateRelcache(targetrel->relation)` with `GetPubPartitionOptionRelations(..., PUBLICATION_PART_ALL, relid)` + `InvalidatePublicationRels()`. Now only the named relation is invalidated, not its partitions.
- `src/backend/commands/publicationcmds.c`, `RemovePublicationRelById()`: traces to the hunk doing the same in the removal path. Now only `pubrel->prrelid` is invalidated.

Result: adding or dropping a partitioned table in a publication leaves its partitions' relcache entries stale.

Failing oracle case: `src/test/regress||publication`
