# Rationale

**Bug:** The CJS loader's per-`require` stat cache (`statCache` in `stat()`) cached every `internalModuleStat` result, including failures (negative values for "not found"). If a file was missing on a first `require` and then created during the same top-level module execution, a second `require` hit the cached "not found" and threw MODULE_NOT_FOUND.

**Hunk (lib/internal/modules/cjs/loader.js, `stat()`):** corresponds to the fix's single implementation hunk. The fix guarded `statCache.set` with `result >= 0`; I removed that guard so the result is always cached (`if (statCache !== null) statCache.set(filename, result);`), restoring the pre-fix behaviour.

**Failing test:** `parallel/test-module-cache` fails: the second `require(filePath)` after `fs.writeFileSync` throws `Error: Cannot find module '.../test-module-cache.json'` (MODULE_NOT_FOUND).
