# Rationale

## Changed hunk
- File: `src/backend/replication/logical/proto.c`, function `logicalrep_write_attrs`.
- Traces to the proto.c hunk of fix.patch, which replaced `RelationGetIndexAttrBitmap(rel, INDEX_ATTR_BITMAP_IDENTITY_KEY)` with `RelationGetIdentityKeyBitmap(rel)`.
- The change reverts that replacement. `RelationGetIndexAttrBitmap` takes a lock on the replica identity index. TRUNCATE already holds an exclusive lock on that index and waits for synchronous replication at commit. The walsender then blocks on the index lock, so the two deadlock. This is the bug the fix removed.
- `RelationGetIdentityKeyBitmap` (the relcache.c and relcache.h hunks) is left in place but is now unused. Removing it is not needed to bring the bug back.

## Failing oracle cases
Expected to fail: "check synchronous logical replication" in t/010_truncate.pl. The later cases in that file may fail too, because the test hangs or dies.
