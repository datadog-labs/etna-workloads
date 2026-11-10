# Re-introduced bug: structuredClone() with no arguments does not throw

## Bug
`structuredClone()` called with zero arguments should throw `ERR_MISSING_ARGS`. Before the fix
(nodejs/node#41651) it silently cloned `undefined` and returned `undefined`.

## Change (lib/internal/worker/js_transferable.js)
The implementation moved since the fix (lib/internal/structured_clone.js no longer exists; the
function is now in lib/internal/worker/js_transferable.js).
- Hunk 1: removed the `if (arguments.length === 0) throw new ERR_MISSING_ARGS(...)` guard. This
  corresponds to the fix's added guard in `structuredClone`; without it a zero-arg call falls
  through to the primitive fast path and returns `undefined`.
- Hunk 2: removed the `ERR_MISSING_ARGS` import, which is now unused. This corresponds to the
  fix's added `ERR_MISSING_ARGS` require.

## Failing test
`parallel/test-structuredClone-global` fails (ran twice, stable):
`assert.throws(() => structuredClone(), { code: 'ERR_MISSING_ARGS' })` fails with
`ERR_ASSERTION` (Missing expected exception).
