# Rationale

**Bug:** `require()` of `node:`-prefixed builtins mishandled sync resolve/load hooks. The `node:` branch of `Module._load` ran `loadBuiltinWithHooks` using the resolved `filename` for any request starting with `node:`, even when a resolve hook redirected it to an on-disk file. It also discarded the load hook's result, so a hook could not override the builtin's format.

**Change** (lib/internal/modules/cjs/loader.js, `Module._load`): one hunk. It corresponds to the fix's hunk that replaced the `node:` block.
- The old condition `StringPrototypeStartsWith(request, 'node:')` is restored in place of `request === url && ...`.
- The `BuiltinModule.normalizeRequirableId` check is removed. The old code passed `filename` straight to `loadBuiltinWithHooks`.
- The result handling that set `resultFromLoadHook` and `format` is removed. The old code ignored the hook's overriding result.

With a redirect to a disk file, `loadBuiltinModule(<path>)` returns undefined, which gives the TypeError below.

**Failing tests** (stable across 2 runs):
- `test-module-hooks-resolve-builtin-on-disk-require-with-prefix`: `TypeError: Cannot read properties of undefined (reading 'exports')`
- `test-module-hooks-resolve-load-builtin-override-both-prefix`: fails because the redirect to a file URL is not honoured. I did not capture its message.
