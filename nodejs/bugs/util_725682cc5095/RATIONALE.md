# Re-introduced bug: util.inspect of typed arrays with a broken `length`

**Bug.** `formatTypedArray` read `value.length` (an own, overridable property) instead of the real length captured earlier (`size`). If a typed array's `length` was redefined to something invalid (e.g. -1), `util.inspect()` computed an invalid `maxLength` and threw `RangeError: Invalid array length` (or printed wrong output).

**Hunks** (both in lib/internal/util/inspect.js; today's code uses `FunctionPrototypeBind`):
1. `formatter = FunctionPrototypeBind(formatTypedArray, null, bound, size)` -> `(..., null, bound)`. Corresponds to fix hunk 1 (no longer passes the original size).
2. `formatTypedArray(value, length, ctx)` -> `(value, ctx)` and `maxLength = MathMin(MathMax(0, ctx.maxArrayLength), value.length)`. Corresponds to fix hunk 2; it restores reliance on the patchable `value.length`.

**Failing test.** `parallel/test-util-inspect` fails (`not ok`, stable across two runs) with `RangeError: Invalid array length`, from the brokenLength case (Float32Array with `length` defined as -1).
