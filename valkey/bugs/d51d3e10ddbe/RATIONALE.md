# Rationale

## Changed: src/db.c, dbSetValue
Removed the block (added by the fix) that, when overwriting a hash with volatile
fields, calls `dbUntrackKeyWithVolatileItems()` on the old object. In 9.0.7 the
block had been extended (`old->hasembkey ? old : new`), but it is the same
hunk. The `dbTrackKeyWithVolatileItems(db, new)` call is kept (the fix hunk's
second part, still present). Without the untrack, overwriting a hash that has
volatile fields (e.g. via SET) leaves the key in `keys_with_volatile_items`
tracking: stale/dangling entry and type confusion.

## Oracle failures
- "Overwriting hash with volatile fields updates keys_with_volatile_items tracking":
  after SET over the hash, INFO keyspace still shows keys_with_volatile_items=1.
- "Zero is a valid ttl in HFE" also fails (collateral effect of stale tracking
  or flakiness; not separately investigated).
