# Bug
`eventNames()` on streams returned events that have no listeners. Stream constructors/destroy leave keys in `_events` with `undefined` values (e.g. 'close','end','readable'), and `eventNames()` reported every own key of `_events`.

# Changes
1. `lib/internal/streams/legacy.js`: removed the `Stream.prototype.eventNames` override (and the now-unused `ReflectOwnKeys` primordial import). Corresponds to the fix's only implementation hunk (adding that override).
2. `lib/events.js`: `EventEmitter.prototype.eventNames` today filters out `undefined` entries, so removing the override alone doesn't bring the bug back. Restored the pre-filter implementation `return this._eventsCount > 0 ? ReflectOwnKeys(this._events) : [];`, i.e. the behaviour the stream had before the fix (inherited unfiltered key listing).

# Failing test
`parallel/test-stream-event-names`: AssertionError, actual `['close','error','data','end','readable','foo']`, expected `['error','data','foo']`.
