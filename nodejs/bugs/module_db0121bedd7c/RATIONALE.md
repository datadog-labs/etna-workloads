# Rationale

**Bug:** `module.enableCompileCache()` options object used the key `path` instead of `directory` (inconsistent with the returned result), and did not honour env overrides: `NODE_COMPILE_CACHE` for the directory and `NODE_COMPILE_CACHE_PORTABLE` for `portable` (default was hard-coded `false`).

**Change (lib/internal/modules/helpers.js, `enableCompileCache`)**, mirroring the fix's single implementation hunk:
- destructuring `({ directory, portable, readOnly } = options)` -> `({ path: directory, portable = false, readOnly } = options)` (old option name, old portable default).
- default directory no longer consults `process.env.NODE_COMPILE_CACHE`.
- removed the `portable === undefined` fallback to `NODE_COMPILE_CACHE_PORTABLE`.
(readOnly handling, added after the fix, is left intact.) Doc comment left untouched.

**Failing tests** (stable over 2 runs): `parallel/test-compile-cache-api-portable` and `parallel/test-compile-cache-api-options-portable-env` both report "not ok" — the `{directory: ...}` option is ignored, so the cache is written to the default tmpdir location instead of the requested one and the expected `.compile_cache` output assertions fail.
