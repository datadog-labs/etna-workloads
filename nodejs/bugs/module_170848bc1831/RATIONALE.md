# Rationale

Bug: when sync hooks (`registerHooks`) are mixed with async hooks (`module.register`), the default step of the async loader returns `source: null` for CommonJS. The sync-hook chain validated that result strictly and threw `ERR_INVALID_RETURN_PROPERTY_VALUE`, so mixing the two broke for CJS entry points.

Change (lib/internal/modules/esm/loader.js, the sync-hook load path used when async hooks are chained in the default step): it now passes `validateLoadStrict` instead of `validateLoadSloppy` (import and call site). This corresponds to the fix hunk that added `validateLoadSloppy` to the ESM loader's `loadWithHooks` call. Reverting to strict validation restores the old behaviour that rejects null CJS source.

Failing test: module-hooks/test-module-hooks-load-async-and-sync (`sync-forward` + `async-forward` case): `ERR_INVALID_RETURN_PROPERTY_VALUE`, process terminated with status 1, expected 0.
