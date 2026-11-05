# Rationale

The fix added `&& indexInfo->ii_AmCache` in `index_insert_cleanup()` (indexam.c). In REL_18_6 that
check moved into the AM callback: `brininsertcleanup()` bails out when `ii_AmCache` is NULL.

## Changed hunk
- `src/backend/access/brin/brin.c`, `brininsertcleanup()`: removed the
  `if (bistate == NULL) return;` guard. This traces to the fix.patch hunk in `index_insert_cleanup`
  that skipped the cleanup when `ii_AmCache` is NULL. Without it, cleanup runs when no insert
  initialised the cache, and it dereferences the NULL `bistate`, which crashes the backend.

## Failing oracle cases
- src/test/regress||brin
