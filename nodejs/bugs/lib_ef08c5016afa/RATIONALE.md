# Re-introduced bug: ConvertToInt modulo handling (lib/internal/webidl.js)

Bug: `convertToInt` wrapped 64-bit values with Number arithmetic, not exact BigInt modulo. The Number `modulo()` helper returned the raw JS remainder, so negative inputs stayed negative and were not mapped to the mathematical modulo (e.g. -1 mod 4096 gave -1, not 4095). 64-bit values beyond 2^53 also lost precision.

Hunks (all in lib/internal/webidl.js):
1. `modulo()`: now `return r;` instead of `return r > 0 ? r : r + y;`. This matches the fix hunk "Normalize mathematical modulo results", reverted to the old raw-remainder behaviour.
2. Removed the `if (bitLength === 64) { ... BigInt / bigIntModulo ... }` block in `convertToInt`. This matches the fix hunk "Use exact BigInt modulo for 64-bit ConvertToInt wrapping". 64-bit values now go through the generic Number `modulo(x, pow2(bitLength))` path.

The `BigInt` import, `BIGINT_2_63`/`BIGINT_2_64` and `bigIntModulo` are now unused. I left them in place to keep the diff small.

Failing tests with the change (stable across 2 runs): parallel/test-internal-webidl-converttoint (`actual: -1, expected: 4095`), parallel/test-internal-webidl-buffer-source and parallel/test-webcrypto-webidl. parallel/test-abortsignal-any failed in run 1 and passed in run 2, so it is flaky. I did not look at why the buffer-source and webcrypto tests fail.
