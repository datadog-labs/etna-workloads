# Re-introduced bug: overzealous top-level await in REPL

**Bug:** The REPL transformed a final expression statement into `return (expr)` from an async IIFE. Because async functions flatten returned promises, an expression like `(await x).y` or `await Promise.resolve(1), Promise.resolve(2)` whose value is a Promise got awaited a second time, so the REPL printed the resolved value instead of the Promise.

## Hunks
1. `lib/internal/repl/await.js`: the fix wrapped the result as `return { value: (expr) }`. I restored the old `state.prepend(node, 'return (')` / `state.append(node.expression, ')')` and removed the wrapper and its comment.
2. `lib/repl.js`: the fix unwrapped with `(await promise)?.value`. I restored `const result = await promise;`, which matches the old code and is needed now that no wrapper object is produced.

## Failing tests
- parallel/test-repl-preprocess-top-level-await: the expected transformed source contains `{ value: ...}`, which the old code no longer emits.
- parallel/test-repl-top-level-await: the regression cases, e.g. `await Promise.resolve(123), Promise.resolve(456)`, now print the resolved value instead of `Promise {`.

Both showed "not ok" in TAP output. I did not capture the failure messages.
