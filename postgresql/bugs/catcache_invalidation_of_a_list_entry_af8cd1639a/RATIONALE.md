# Rationale

Hunk: src/backend/utils/cache/catcache.c, `CatCacheInvalidate()`.
Traces to fix.patch hunk "Also invalidate any entries that are being built"
(`if (e->list || e->hash_value == hashValue) e->dead = true;`).
Changed to `if (!e->list && e->hash_value == hashValue)`, so an invalidation
arriving while a CatCList is being built no longer marks the in-progress list
entry dead. The list build then doesn't retry and a concurrently-added tuple that
belongs in the list is missed, so the stale list is cached. This is the original bug.

Failing oracle cases (test script aborts mid-run, reported as missing):
- src/test/modules/test_misc|t/007_catcache_inval.pl|#1
- src/test/modules/test_misc|t/007_catcache_inval.pl|#2
