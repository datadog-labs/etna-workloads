# Bug
`require.resolve.paths('node:fs')` returned a node_modules lookup array instead of `null` for builtins requested with the `node:` scheme (only scheme-less builtins returned `null`).

# Change
lib/internal/modules/cjs/loader.js, `Module._resolveLookupPaths`: the fix's single hunk added a `node:`-prefix branch. In today's code that logic lives in `BuiltinModule.normalizeRequirableId(request)`, so I replaced that call with the pre-fix condition
`BuiltinModule.canBeRequiredByUsers(request) && BuiltinModule.canBeRequiredWithoutScheme(request)`.
This only matches scheme-less ids, so `node:`-prefixed builtins fall through to the path-lookup branch.

# Failing test
parallel/test-require-resolve: `not ok` (stable over 2 runs), "AssertionError [ERR_ASSERTION]: Expected values to be strictly equal" from `require.resolve.paths('node:<mod>')` not being null.
