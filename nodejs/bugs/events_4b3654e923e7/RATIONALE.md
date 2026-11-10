# Rationale

**Bug:** `events.once` (and the shared add-listener helper) did not prioritize EventEmitter semantics: any object exposing `addEventListener` was treated as a DOM-style EventTarget, even if it was also an EventEmitter (e.g. an emitter with an `addEventListener` property, or NodeEventTarget). The fix made the helper check `emitter.on` first.

**Hunk:** `lib/events.js`, `eventTargetAgnosticAddListener`: swapped branch order so `addEventListener` is checked before `on`. This corresponds to the fix's `eventTargetAgnosticAddListener`/`once` refactor, which established EventEmitter-first priority (before the fix, `once` checked `addEventListener` first). The release's `once` already routes through this helper, so reordering restores the old behaviour.

**Failing test:** `parallel/test-events-once` — `not ok`, `AssertionError [ERR_ASSERTION]: foo` (from `prioritizesEventEmitter`, where `ee.addEventListener = fail` is called). Stable across 2 runs.
