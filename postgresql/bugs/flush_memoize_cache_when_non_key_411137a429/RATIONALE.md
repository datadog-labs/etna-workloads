# Rationale

## src/backend/executor/nodeMemoize.c, ExecReScanMemoize()
Traces to the fix.patch hunk in `ExecReScanMemoize` that added
`if (bms_nonempty_difference(outerPlan->chgParam, node->keyparamids)) cache_purge_all(node);`.
I removed that check. When a parameter that is not part of the cache key changes, the
Memoize cache is no longer flushed, so stale cached results are returned again.
The rest of the fix (keyparamids plumbing, cache_purge_all, pull_paramids) is left in place.
That is harmless: cache_purge_all is now unused, but nothing else depends on it.

## Failing oracle cases
- src/test/regress||memoize
