# Rationale

## Bug
Since v19.2, `stream.Duplex` was read from the `streams/legacy` module (`Stream.Duplex`), which only has
`Duplex` once `lib/stream.js` has run. When only `node:stream/promises` was loaded (never `stream`),
the property was `undefined`, so `pipeline()` with async generator functions failed with a TypeError.
The upstream fix added `require('stream');` to `lib/stream/promises.js` so that `Stream.Duplex` is populated.

## Change
Plain reversal (removing `require('stream')` from `lib/stream/promises.js`) no longer reproduces the bug,
because `pipeline.js` and the rest of the code now import `internal/streams/duplex` directly. So the
defect is re-expressed in the code that now sits on the same path:

- `lib/stream/promises.js`: removed `require('stream');` (reverse of the fix hunk).
- `lib/internal/streams/transform.js`: `Duplex` is read from `require('internal/streams/legacy').Stream.Duplex`
  instead of `require('internal/streams/duplex')`. The lazily created `PassThrough` (used when the last pipeline
  argument is a function) loads `transform.js`. If `stream` was never required, `Stream.Duplex` is `undefined`,
  which restores the old "Duplex read from legacy" defect.

## Failing test
`parallel/test-stream3-pipeline-async-iterator` fails (checked twice) with
`TypeError: Cannot read properties of undefined (reading 'prototype')`.
