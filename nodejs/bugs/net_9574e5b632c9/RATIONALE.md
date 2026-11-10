# Re-introduced bug: blockList.addSubnet accepts NaN prefix (fix 9574e5b632c9)

**Bug:** `BlockList.prototype.addSubnet` validated the prefix with plain comparisons (`prefix < 0 || prefix > N`) and a `typeof` check. `NaN` passes both, so it is not rejected with `ERR_OUT_OF_RANGE` and reaches the native handle.

**Change (lib/internal/blocklist.js, only addSubnet):**
- Hunk 1 (import): add `ERR_OUT_OF_RANGE` to the imported errors. This matches the fix's import hunk, reversed. `validateInt32` stays imported because `removeSubnet` still uses it.
- Hunk 2 (ipv4/ipv6 cases): replace `validateInt32(prefix,'prefix',0,32/128)` with manual range checks that throw `ERR_OUT_OF_RANGE`. This matches the fix's ipv4/ipv6 hunk, reversed.
- Hunk 3: re-add the `typeof prefix !== 'number'` check, matching the fix's removed type-check hunk. It sits after the range checks because today's code has the family derived from the SocketAddress.

**Failing test:** `parallel/test-blocklist` (`not ok`). The `assert.throws(() => blockList.addSubnet('', NaN), /ERR_OUT_OF_RANGE/)` case fails because no matching error is thrown. The failure was stable over repeated runs.
