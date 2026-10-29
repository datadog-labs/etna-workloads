# Rationale

Fix: "Avoid unsigned integer overflow when evaluating an array index in a JSON path expression" (src/json.c, jsonLookupStep, `[` branch).

Changed (tree/src/json.c, jsonLookupStep, `zPath[0]=='['` branch), reversing the single implementation hunk:
- The array index accumulator `kk` is a `u32` again (fix widened it to `u64`), and the digit loop is back to the unguarded `kk = kk*10 + digit`, so large indexes wrap modulo 2^32.
- The `$[#-N]` offset `nn` is `unsigned int` again with the unguarded `nn = nn*10 + digit` (fix: `u64` plus saturation at 0xffffffff).
(The variable name `kk` was kept; the pre-fix code called it `k`. Behaviour is identical.)

Oracle failures: json102-445-4, 445-5, 445-7. `json_remove('[0,1,2,3,4]','$[4294967296]')` wraps the index to 0 and removes element 0; 4294967297 wraps to 1; 42949672960 wraps to 0. Expected the array unchanged. The json105 `#-N` cases still pass (the wrapped values happen to exceed the count).
