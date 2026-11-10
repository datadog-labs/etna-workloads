# Re-introduced bug: push() signal abort reason replaced with AbortError

**Bug:** When the stream-wide `signal` passed to `push()` aborted, `PushQueue` only forwarded the reason to `fail()` if `isError(reason)`; otherwise (e.g. `ac.abort('test reason')`) it substituted a generic `AbortError` DOMException, losing valid non-Error reasons.

**Hunks (lib/internal/streams/iter/push.js):**
1. Import: `const { lazyDOMException } = require('internal/util')` in the fix -> restored as `{ isError, lazyDOMException }` (the imports had been removed after the fix, so they are re-added).
2. Abort handler: `this.fail(this.#signal.reason)` -> `this.fail(isError(reason) ? reason : lazyDOMException('Aborted','AbortError'))`, the pre-fix behaviour.

**Failing test:** `parallel/test-stream-iter-push-basic` is `not ok` (stable over 2 runs). The `testAbortSignalReason` case rejects with an AbortError instead of the `'test reason'` string. I only checked the TAP "not ok" line, not the exact message text.
