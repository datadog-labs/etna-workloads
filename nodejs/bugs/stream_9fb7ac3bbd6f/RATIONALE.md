# Re-introduced bug: pipeline() leaks listeners when last stream is readable

**Bug.** When the last stream of `stream.pipeline()` is readable (e.g. a Duplex/Transform), pipeline
adds `error`/eos listeners to it and never removes them on successful completion. Later errors on that
stream are still routed to pipeline's handlers (and listenerCount('error') stays > 0), which prevents
the expected uncaught exception (nodejs/node#35452).

**Change (lib/internal/streams/pipeline.js, one hunk).** In `finish()`, removed
```js
if (!error) { lastStreamCleanup.forEach((fn) => fn()); }
```
This corresponds to the fix hunk `if (final) { if (!error) { lastStreamCleanup.forEach(...) } ... }`.
The other fix hunks only collect the cleanup functions (destroyer returning `cleanup`, `pipe` returning
eos cleanup, the `onError` removal closure); they are inert without the call, so the old behaviour
(listeners never removed after success) is restored. The collection code remains in the tree as dead
bookkeeping because the release has diverged from the pre-fix code.

**Failing test.** `parallel/test-stream-pipeline-listeners` -> `not ok` (stable over 2 runs): after the
callback `b.listenerCount('error')` is not 0 (assertion failure) / the expected uncaught 'no way' exceptions don't occur.
