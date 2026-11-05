# Rationale

Reverts "plan caching honors search_path changes" (0d5fbdc157a1) in `src/backend/utils/cache/plancache.c`.
In today's code the fix is expressed via `SearchPathMatchesCurrentEnvironment`, not `OverrideSearchPathMatchesCurrent`.

Hunks (all trace to the fix's RevalidateCachedQuery hunk, "check to see if that matches the current environment; if not force replan"):
1. `RevalidateCachedQuery`: removed the block that invalidates the querytree and generic plan when the saved search_path differs from the current one. Cached plans are then no longer re-analyzed after search_path changes.
2. `CheckCachedPlan`: removed the "is the search_path still the same" check that rejected the generic plan. This is the modern equivalent of the fix's gplan invalidation.
3. Removed the matching Assert in the plan-building function. It would fire once the check is gone.

Oracle case expected to fail: src/test/regress||plancache
