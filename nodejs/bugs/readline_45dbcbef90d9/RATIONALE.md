# Re-introduced bug: readline.cursorTo does not reject NaN

## Bug
`readline.cursorTo(stream, x, y)` silently accepted `NaN` for `x` or `y`. With NaN, neither
argument passes a validity check, so the call either became a no-op or wrote a bogus escape
sequence (`\x1b[NaNG`) instead of throwing `ERR_INVALID_ARG_VALUE`.

## Change (lib/internal/readline/callbacks.js)
In the release, `cursorTo` lives in `lib/internal/readline/callbacks.js` (it was `lib/readline.js` upstream).
- Hunk 1: removed the two checks `if (NumberIsNaN(x)) throw new ERR_INVALID_ARG_VALUE('x', x);` and
  the same for `y`. This is the reverse of the fix's only implementation hunk; without it NaN is
  never rejected.
- Hunk 2 (cleanup, no behaviour change): dropped the now-unused `NumberIsNaN` and
  `ERR_INVALID_ARG_VALUE` imports so lint stays clean.

## Failing test
`parallel/test-readline-csi` fails:
`AssertionError [ERR_ASSERTION]: Missing expected exception.` at test-readline-csi.js:166
(`readline.cursorTo(writable, NaN)` expected to throw `/ERR_INVALID_ARG_VALUE/`).
