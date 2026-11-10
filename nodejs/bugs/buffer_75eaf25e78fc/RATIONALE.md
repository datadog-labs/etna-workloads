# Rationale

**Bug:** `Buffer.from()` validated its input loosely. Functions were not rejected: `Buffer.from(fn)` returned a Buffer built from the function's `length`, because functions fall through to `fromObject`. `null`, `undefined`, numbers and symbols were handled by ad-hoc checks (a special "not number" error), and other primitives were not consistently rejected.

**Change (lib/buffer.js, `Buffer.from`):** one hunk, matching the fix's single implementation hunk. The fix wrapped the object-handling logic in `if (typeof value === 'object' && value !== null)`. I removed that wrapper and restored the pre-fix flow, re-expressed for today's code (`from`, `SymbolToPrimitive`, the `typeof valueOf` checks):
- The ArrayBuffer check runs for any value.
- `null`/`undefined` throw `ERR_INVALID_ARG_TYPE('first argument', ...)`.
- A `number` throws `ERR_INVALID_ARG_TYPE('value', 'not number', ...)`.
- Everything else, including functions, goes through `valueOf`, `fromObject` and `toPrimitive`.

**Failing test:** `parallel/test-buffer-from` fails (`not ok`) on two runs. `Buffer.from(function)` no longer throws, and the number case produces the old "not number" message. The assertion output reports an unexpected/missing error: expected `The first argument must be of type string or an instance of Buffer, ArrayBuffer, or Array or an Array-like Object. Received function ...`.
