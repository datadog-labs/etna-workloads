# Bug
Resolve hooks (registerHooks) were invoked twice for imported CJS: once by the ESM loader and again from the
synthetic-module evaluation step, which calls Module._load on the resolved path and re-ran the resolve hooks.
The fix passed a `shouldSkipModuleHooks` option to avoid this.

# Changes
- lib/internal/modules/cjs/loader.js, resolveForCJSWithHooks: fast-path condition
  `!resolveHooks.length || shouldSkipModuleHooks` -> `!resolveHooks.length` (corresponds to the fix hunk that added
  the `|| shouldSkipModuleHooks` check). Hooks now run even when the option is passed.
- lib/internal/modules/esm/translators.js: the three wrapModuleLoad calls (`.node` require, createCJSNoSourceModuleWrap,
  loadCJSModuleWithModuleLoad else-branch) no longer pass kShouldSkipModuleHooks (corresponds to the fix's translators hunks).

# Failing test
module-hooks/test-module-hooks-resolve-import-cjs: not ok — the resolve hook is called a second time with the
absolute path, failing `strictEqual(specifier, '../fixtures/value.cjs')`.
(load-import-cjs still passes.)
