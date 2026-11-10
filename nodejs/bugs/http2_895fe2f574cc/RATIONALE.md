# Re-introducing nodejs/node 895fe2f (http2: fix session[kSession] undefined issue)

## Bug
`Http2Stream[kMaybeDestroy]` reads `this[kSession][kType]` after a stream has
already been destroyed (`_destroy` sets `this[kSession] = undefined`), throwing
`TypeError: Cannot read properties of undefined (reading 'Symbol(type)')`,
e.g. when a client does `session.request({':method':'POST'}).end(cb)` and then
`session.destroy()`.

## Changes (lib/internal/http2/core.js, `Http2Stream[kMaybeDestroy]`)
1. Removed `this[kSession] &&` from the graceful-close condition. This is the
   exact reverse of the fix's only implementation hunk.
2. Removed the `return;` after `this.destroy()` in the
   `!this.readable && this.closed` branch. Today's code has this early return,
   which makes the guard unreachable for destroyed streams (plain reversal of
   hunk 1 alone left the test passing). Without the return, an already-destroyed
   stream falls through to the unguarded `this[kSession][kType]` read, as in the
   pre-fix code.

## Failing test
`parallel/test-http2-server-session-destroy` (fails on both runs):
`TypeError: Cannot read properties of undefined (reading 'Symbol(type)')`
