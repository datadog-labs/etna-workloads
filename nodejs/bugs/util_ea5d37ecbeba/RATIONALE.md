# Rationale

**Bug:** `util.inspect` of an Error whose `stack` is not a string (e.g. `Error.prepareStackTrace = e => e`, or `error.stack = error`) formatted `error.stack` directly via `formatValue` without registering the error in `ctx.seen`. A stack pointing to itself therefore recursed (crash / stack overflow), and non-string stacks lost the `Error: message` header and indentation.

**Change (lib/internal/util/inspect.js, `getStackString`):** the single fix hunk replaced `return formatValue(ctx, error.stack)` with push to `ctx.seen`, indentation +4, format, pop, and a `${ErrorPrototypeToString(error)}\n    ${result}` return. Today's code uses a local `stack` variable; I reverted the block to `return formatValue(ctx, stack);`, restoring the old behaviour.

**Failing test:** `parallel/test-util-inspect` fails (stable across runs):
`actual: '[404]', expected: '[RangeError: foo\n    404]'`
(the self-referencing stack cases also regress).
