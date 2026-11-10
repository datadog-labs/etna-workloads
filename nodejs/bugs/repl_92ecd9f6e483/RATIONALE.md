# Rationale

**Bug:** In the REPL's top-level-await preprocessing, only the very last statement of the body was checked for being an ExpressionStatement. If the input ended with empty statements (e.g. `await 0;;;`), the last node was an EmptyStatement, so the `return` wrapper was not added and the REPL result was lost (undefined).

**Change (lib/internal/repl/await.js, one hunk):** The fix replaced the single `last` check with a backwards loop that skips `EmptyStatement` nodes and then breaks. I reverted that loop to a single check of `body.body[body.body.length - 1]`, with no skipping of EmptyStatements. The current code also has the `{ value: ... }` wrapper, which I left untouched.

**Failing test:** parallel/test-repl-preprocess-top-level-await (stable over 2 runs):
actual: `(async () => { await 0;;; })()`
expected: `(async () => { return { value: (await 0) };;; })()`
