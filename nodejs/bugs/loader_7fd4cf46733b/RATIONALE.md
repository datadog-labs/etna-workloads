# Re-introduced bug: `require.resolve('node:unknown')` does not throw

**Bug:** `require.resolve()` with a `node:`-prefixed request returned the request unchanged even when the builtin does not exist (e.g. `require.resolve('node:unknown')` returned `'node:unknown'`) instead of throwing `MODULE_NOT_FOUND`.

**Change (lib/internal/modules/cjs/loader.js, `Module._resolveFilename`):** the early-return condition now also accepts any request starting with `node:` (`StringPrototypeStartsWith(request, 'node:') || BuiltinModule.normalizeRequirableId(request)`).
This corresponds to the fix's `_resolveFilename` hunk, which had added the `canBeRequiredByUsers(request.slice(5))` check to the `node:` branch. Removing that validation restores the old behaviour. The fix's `Module._load` hunk needs no counterpart: in today's code `defaultResolveImplForCJSLoading` already handles `node:` before `_resolveFilename`, so `require('node:unknown')` still throws `ERR_UNKNOWN_BUILTIN_MODULE`.

**Failing test:** `parallel/test-require-resolve` fails with `AssertionError: Missing expected exception` (`expected: { code: 'MODULE_NOT_FOUND' }`, at the `require.resolve('node:unknown')` assertion).
