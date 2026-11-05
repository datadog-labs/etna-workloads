# Rationale

Hunk: src/backend/executor/nodeMemoize.c, ExecReScanMemoize.
Traces to the fix_impl.patch hunk in ExecReScanMemoize that adds
`if (bms_nonempty_difference(outerPlan->chgParam, node->keyparamids)) cache_purge_all(node);`.
I removed that check. The cache is no longer flushed when a parameter that is not
part of the cache key changes, so stale cached results can be returned.
The rest of the fix (keyparamids plumbing, cache_purge_all) is left in place but is now unused.

Failing oracle case: src/test/regress||memoize
