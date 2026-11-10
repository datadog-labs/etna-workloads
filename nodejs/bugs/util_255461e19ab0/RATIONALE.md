# Rationale

**Bug:** `util.inspect()` of an error whose `stack` is set to a non-string (e.g. 404, an array) does not coerce/handle it as a string; the raw value is used as the stack (upstream: it could throw; with today's primordials it yields a wrong output such as `[404]` / `[1,2,3]`).

**Hunk (lib/internal/util/inspect.js, `getStackString`)** corresponds to the fix's change `err.stack ? String(err.stack) : ErrorPrototypeToString(err)` in `formatError`. In today's code that coercion lives in `getStackString`, where non-string stacks were formatted via `formatValue`. I removed the `typeof stack === 'string'` branch so the stack is returned as-is, restoring the pre-fix behaviour of using the non-string stack value untouched.

**Failing test:** `parallel/test-util-inspect` (stable over 2 runs): `actual: '[404]'`, `expected: '[RangeError: foo\n    404]'`.
