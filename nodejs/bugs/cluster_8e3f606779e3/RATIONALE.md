# Re-introduced bug: cluster child index tracking (nodejs/node#36764)

**Bug.** In `lib/internal/cluster/child.js`, the child kept one numeric counter per
`indexesKey` (address:port:addressType:fd). When any server/socket sharing that key
closed, the whole key was deleted. With port 0, several listeners share a key, so
closing one resets the counter and drops the key. A later listener then reuses an index,
and the `listening` handler sees the key missing and returns early. The primary and child
get out of sync, which gives ERR_INTERNAL_ASSERTION, hangs, or ERR_SOCKET_DGRAM_NOT_RUNNING.

**Hunks (all in lib/internal/cluster/child.js).**
1. `_getServer`: the `{nextIndex, set: SafeSet}` bookkeeping is replaced by the old plain
   numeric counter (`index = undefined ? 0 : index+1; indexes.set(key, index)`). This
   matches the fix's hunk at `let indexSet = indexes.get(...)`.
2. Removed `removeIndexesKey()` and the unused `SafeSet` import. These match the fix's
   added helper and import.
3. In `shared()` and `rr()` (the release passes `{indexesKey, index}` objects), the
   `removeIndexesKey(indexesKey, index)` calls are back to `indexes.delete(indexesKey)`.
   This matches the fix's two replaced `indexes.delete` calls. The `index` parameter stays
   in the release's signatures, since only the helper used it.

**Results.** `parallel/test-cluster-child-index-net` hangs and fails (timed out; run
directly it never exits, rc=124). `parallel/test-cluster-child-index-dgram` passed in my
run, so only the net test is a reliable failure.
