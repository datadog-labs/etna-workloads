# Re-introduced bug: MessageEvent not Web-compatible (nodejs/node#35496)

**Bug.** `MessageEvent` was a bare `Event` subclass with the positional constructor `(data, target, type)`. It did no validation and set `data` as a plain own property. `origin`, `lastEventId`, `source` and `ports` were missing. `new MessageEvent('message', {...})` therefore built an event whose type was `undefined` and whose data was the string `'message'`.

**Today's code.** The release already had undici's `MessageEvent` as the global, so the fix's hunks cannot be reversed directly. The change below brings the old class back and makes it the global again.

## Hunks
1. `lib/internal/worker/io.js`: replaces the undici-backed `lazyMessageEvent`.
   - Corresponds to the fix's `MessageEvent` class hunk, where the constructor became `(type, init)` with validated fields and getters.
   - It restores the old `class MessageEvent extends Event { constructor(data, target, type) }` with only `this.data`.
   - `lazyMessageEvent(type, init)` now builds that class and drops `ports`. This matches the old `kCreateEvent` returning `new MessageEvent(data, this, type)`.
2. `lib/internal/worker/io.js` exports: `MessageEvent` is added to `module.exports`. The fix added the same export.
3. `lib/internal/bootstrap/web/exposed-window-or-worker.js`: the global `MessageEvent` is no longer exposed from undici. It is exposed from `internal/worker/io`, so the global shows the old behaviour.

I made no change for the fix's C++ `checkMessagePort`. Only the validation that used it is gone, and the binding is now unused.

## Failing test
`parallel/test-worker-message-event` fails with the old class. `new MessageEvent('message')` gives:
```
AssertionError [ERR_ASSERTION]: Expected values to be strictly deep-equal:
+ actual - expected
  data: null, lastEventId: '', origin: '', ports: [], source: null, type: 'message'
- data: 'message', lastEventId: undefined, origin: undefined, ports: undefined, source: undefined, type: 'undefined'
```
