# Re-introduced bug: premature close when stream will not emit 'close' (nodejs/node#45281)

## Bug
`finished()/eos()` on a stream that is already finished/ended on the side being watched
(e.g. `Duplex` with `{ readable: false }` after `end()`, write callback still pending) and
that will not emit 'close' reports `ERR_STREAM_PREMATURE_CLOSE` instead of waiting for
'finish'/completing without error. The fix made these immediate-settle paths not use the
premature-close check (it used a separate `onclosed` that only reports stream errors).

## Changes (lib/internal/streams/end-of-stream.js)
1. The immediate-result branches (`errorEmitted && !willEmitClose`, `!readable ...`,
   `!writable ...`, `req && aborted`) now compute `getEosOnCloseError(...)` (which can return
   `ERR_STREAM_PREMATURE_CLOSE`) instead of `getEosErrored(stream)`. Corresponds to the fix hunk
   switching `process.nextTick(onclose)` -> `process.nextTick(onclosed)`; reverting it restores
   the old onclose-style check in those branches.
2. Removed the `wState.pendingcb === 0` condition in the `!readable` branch. That guard was added
   after the fix and masks the same defect in today's code (it defers settling while writes are
   pending); without removing it the old behaviour is not reproducible for the fix's test case.

## Failing test
`parallel/test-stream-finished` -> `not ok` (exit code 1, `ERR_ASSERTION`): the new case
`finished(stream, { readable: false }, cb)` after `stream.end('foo')` gets a premature close
error so `assert(!err)` fails. Stable over repeated runs.
