# Re-introduced bug (upstream a705e240b1)

Bug: for core modules that only exist with the `node:` scheme (`node:sea`, `node:sqlite`, `node:test`,
`node:test/reporters`), the URL handed to `module.registerHooks()` resolve/load hooks lost its `node:`
prefix (hooks saw e.g. `test`), because `convertCJSFilenameToURL` used `BuiltinModule.normalizeRequirableId`
on the already-stripped id, which rejects scheme-only ids.

Hunks:
1. `lib/internal/modules/customization_hooks.js` `convertCJSFilenameToURL`: restored the pre-fix body
   (`normalizeRequirableId(filename)` then `node:${id}`), replacing the strip-`node:`/`canBeRequiredByUsers`
   logic (fix hunk 2); removed the now-unused `StringPrototypeSlice` import (fix hunk 1).
   Alone this doesn't fail, since today's CJS loader passes the original specifier as the URL.
2. `lib/internal/modules/cjs/loader.js` `defaultResolveImplForCJSLoading`: no longer returns `url: specifier`
   for `node:` requests, so the URL is derived via `convertCJSFilenameToURL(result.filename)` from the stripped
   id, as before the release moved on. This makes hunk 1's defect reachable again.

Failing tests: both module-hooks/test-module-hooks-builtin-require and
module-hooks/test-module-hooks-load-builtin-require:
`AssertionError [ERR_ASSERTION]: The input did not match the regular expression /^node:/.`
(stable over two runs).
