# Rationale

**Bug:** For CJS imported via `import` and resolved/loaded by a short-circuiting synchronous hook (`module.registerHooks()`), the synthetic module evaluation step re-enters `Module._load` and runs the default resolve/load from disk again, instead of reusing the hook's result. Virtual modules (not on disk) fail with `Cannot find module 'virtual:entry'`.

**Change (one hunk)**, `lib/internal/modules/esm/translators.js`, `loadCJSModuleWithModuleLoad`: the `if (translateContext.isResolvedBySyncHooks)` branch is disabled (`if (false)`), so the pre-resolved `resolved`/`source` options are never passed to `Module._load`. This reverts the fix's translators.js hunk (and effectively the `Module._load` internalOptions.resolved/source handling in cjs/loader.js, which is never reached). Pre-fix code always used `wrapModuleLoad(filename, undefined, isMain, kShouldSkipModuleHooks)`, the else path. Other hunks (loader.js flag plumbing, etc.) were left because the fix's plain reversal doesn't apply and the single switch suffices.

**Failing test:** module-hooks/test-module-hooks-load-import-cjs-custom-source — `Error: Cannot find module 'virtual:entry'` (fails on both runs).
