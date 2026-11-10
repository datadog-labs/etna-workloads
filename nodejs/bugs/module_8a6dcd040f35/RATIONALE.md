# Rationale

**Bug:** the CJS loader's stat cache could persist across top-level `require` calls (e.g. in the REPL, where no `_compile` at depth 0 resets it), and it cached failed lookups. If a file was missing on the first `require` and created afterwards, the second `require` still saw the cached "not found" and failed.

**Changes (lib/internal/modules/cjs/loader.js)**, corresponding to the fix's `stat()` / `statCache` hunk (re-expressed for current code, which already had `statCache = null` initially and only cached successes):
- `let statCache = new SafeMap();` (fix: `= null` instead of `new Map()`): the cache exists outside any `_compile`, so it is live in the REPL.
- `stat()`: lazily recreates the cache if null, and caches every result, including failures (removes the `result >= 0` guard). This matches the pre-fix stat().

The `_compile` hunk of the fix is already present, unchanged.

**Failing test:** parallel/test-repl-require-after-write ("not ok"; REPL writes stderr / output differs from `> 1\n> ` since the second require throws MODULE_NOT_FOUND). Stable across two runs.
