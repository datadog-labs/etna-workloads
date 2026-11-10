# Re-introduced bug: patched module wrapper is ignored

Before the fix (nodejs/node#21573), mutating `Module.wrapper` / `Module.wrap` had no effect on how CJS modules were compiled, because `_compile` always used `compileFunction`, so the wrapper text was never applied. The fix added a `patched` flag, set when the wrapper or `wrap` is modified, and `_compile` reverts to the legacy wrapper path when it is set.

## Change (lib/internal/modules/cjs/loader.js)
The `patched = true;` assignments are removed from the `wrapperProxy` `set` and `defineProperty` traps and from the `Module.wrap` and `Module.wrapper` setters. These correspond to the fix's hunk that introduces those traps and setters, which flip `patched`. With them gone, `patched` stays false, `wrapSafe` always takes the `compileFunctionForCJSLoader` path, and user patches to the wrapper are silently ignored. That matches the pre-fix behaviour. The current tree's `wrapSafe` and the C++ side already differ from the fix's diff, so they were left alone.

## Failing test
`parallel/test-module-wrap` fails (not ok) on two runs. The child process's `assert.strictEqual(mwc, 1)` fails because `global.mwc` stays 0 after `m.wrapper[0] += ...`. `parallel/test-v8-coverage` still passes.
