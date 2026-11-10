# Re-introduced bug: zlib streams don't emit 'close' after 'end'

Before the upstream fix, zlib streams only released the native handle on 'end'
(`_close(this)`), and never destroyed the stream, so 'close' was not emitted
after the readable side ended. The fix made 'end' call `this.close`, which destroys
the stream and so emits 'close'.

## Changes (lib/zlib.js, ZlibBase)
1. Fix hunk: `this.once('end', _close.bind(null, this))` -> `this.once('end', this.close)`.
   Today the release gets 'close' from `autoDestroy: true` in the `Transform.call`
   options instead, so there is no `this.close` listener to revert. I re-expressed the
   old behaviour in two parts:
   - `Transform.call(this, { autoDestroy: false, ...opts })` (was `true`) stops the
     stream being destroyed after 'end'.
   - Re-added `this.once('end', _close.bind(null, this))`, the pre-fix listener that
     closes only the handle and does not destroy the stream.
   Together, 'close' is never emitted after 'end'.

## Failing test
`parallel/test-zlib` fails, stably over repeated runs:
`Mismatched noop function calls. Expected exactly 1, actual 0.`
The failing check is the `.on('close', common.mustCall(1))` added by the fix.
