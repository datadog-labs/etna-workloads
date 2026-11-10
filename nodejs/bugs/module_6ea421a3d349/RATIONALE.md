# Re-introduced bug (fix 6ea421a3d349)

Bug: with synchronous `module.registerHooks()` resolve hooks, changes a hook makes to `context.conditions` are ignored by the default resolvers, so custom conditions have no effect.

## Hunks
1. `lib/internal/modules/esm/loader.js` `#cachedDefaultResolve`: corresponds to the fix's hunk that passes the hook `context` (with its conditions) into `defaultResolve`. It now builds a fresh context using `this.#defaultConditions` again, discarding hook-supplied conditions (ESM path).
2. `lib/internal/modules/cjs/loader.js` `defaultResolve` inside `resolveForCJSWithHooks`: corresponds to the fix's conversion of `context.conditions` into a SafeSet. It now always uses `getCjsConditions()`, ignoring the hook's conditions (and the array validation for ERR_INVALID_ARG_VALUE).

## Failing tests
All three oracle tests fail (`test-module-hooks-custom-conditions`, `-cjs`, `-special-values`). Assertions fail because e.g. `cjs('foo/second').result` is `'default'` rather than `'foo'`.
