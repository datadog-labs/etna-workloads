# Re-introduced bug
`globalThis.fetch` was defined with an anonymous-ish function named `value`, so `fetch.name === 'value'` instead of `'fetch'`.

## Hunk
`lib/internal/bootstrap/web/exposed-window-or-worker.js`: `value: function fetch(input, init = undefined)` -> `value: function value(input, init = undefined)`. This corresponds to the fix's only implementation hunk (reversed; the eslint-disable comment is not needed since the name is the old one and the line differs slightly in today's code).

## Failing test
`parallel/test-global` fails (stable over 2 runs): AssertionError, actual: 'value', expected: 'fetch'.
