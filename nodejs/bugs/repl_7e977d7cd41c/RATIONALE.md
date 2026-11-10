# Rationale

**Bug:** `REPLServer.createContext()` (with `useGlobal: false`) copied every own property of the outer global into the new REPL context, including builtins like `Object`. The REPL context's `Object` was therefore the main context's `Object`, so `{} instanceof Object` evaluated to `false` inside the REPL (the `{}` literal is created with the context's own intrinsic Object.prototype).

**Hunk (lib/repl.js, createContext):** corresponds to the fix's single implementation hunk, which added the `if (!(name in primordials))` guard. Today's code uses `if (!getGlobalBuiltins().has(name))`. I removed that guard so all globals are defined on the context unconditionally, as before the fix.

**Failing test:** `parallel/test-repl-context` fails (stable across two runs):
`AssertionError [ERR_ASSERTION]: Expected "actual" not to be reference-equal to "expected": actual: [Function: Object], expected: [Function: Object]` (from `assert.notStrictEqual(r.context.Object, Object)`).
