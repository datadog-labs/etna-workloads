# Rationale

## Changed hunk
- File: `src/backend/catalog/aclchk.c`, function `object_ownercheck()`.
- Traces to the `aclchk.c` hunk in fix.patch at `object_ownercheck`. That hunk added the translation of `LargeObjectRelationId` to `LargeObjectMetadataRelationId`.
- I removed that translation. Callers such as `be_lo_unlink()` pass `LargeObjectRelationId`, as in the fix. Without the translation, `get_object_catcache_oid(LargeObjectRelationId)` returns -1, so the ownership check takes the generic catalog-scan path. That path scans `pg_largeobject` using the wrong OID and owner attributes, so the ownership check for large objects is wrong. This is the original bug.

## Failing oracle case
- `src/test/regress||largeobject` (confirmed FAIL with agent_oracle.py)
