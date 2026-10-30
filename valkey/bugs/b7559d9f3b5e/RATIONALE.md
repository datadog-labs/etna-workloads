# Rationale

Fix hunks reversed, all in `getKeysUsingKeySpecs` (`src/db.c`; the code was already restructured in 9.0.7 but the fix's changes were still present):

- Local `k` counter restored; `result->numkeys` is no longer updated while keys are appended (reverses the `keys[result->numkeys]...numkeys++` hunk). `result->numkeys = k; return k;` is set only at the end (reverses the final hunk).
- `getKeysPrepareResult(result, result->numkeys + count)` is back to `getKeysPrepareResult(result, count)` (reverses the allocation-size hunk). With numkeys not tracked, a second spec that grows past the 256-entry stack buffer neither copies earlier keys nor allocates room for them.
- The `serverAssert(result->numkeys == 0)` already present in 9.0.7 is kept.

Oracle failure: `COMMAND GETKEYS MORE THAN 256 KEYS` (ZUNIONSTORE with 260 keys, two key specs) fails. The destination key's slot is left uninitialized, and the buffer is too small for the keys.
