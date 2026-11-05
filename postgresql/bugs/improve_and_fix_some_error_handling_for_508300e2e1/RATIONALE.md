# Rationale

## src/backend/commands/indexcmds.c, ReindexRelationConcurrently(), REINDEX_OBJECT_TABLE case
Traces to the first hunk of fix_impl.patch (adds an IsCatalogRelationOid(relationOid) check that
raises ERROR before table_open). In today's code that check (message "cannot reindex system
catalogs concurrently") exists at the same place; I removed it. The message-wording hunks and the
shared-relation hunk were already refactored upstream and were not touched.
Effect: REINDEX TABLE CONCURRENTLY on a system catalog no longer errors up front, so it proceeds
into the concurrent reindex machinery instead of being rejected.

## Failing oracle cases
- src/test/regress||create_index (expected "cannot reindex system catalogs concurrently" error missing)
Confirmed: the oracle run reports FAIL for this case (1/1 failing).
