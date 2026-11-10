# Rationale

**Bug:** `http.IncomingMessage#destroy()` did not return `this`, unlike other readable streams (so chaining / `stream.destroy() === stream` failed).

**Change (lib/_http_incoming.js, one hunk):** The original fix added `return this;` at the end of a custom `IncomingMessage.prototype.destroy`. In v26.13.0 that override no longer exists (destroy is inherited from `Readable`, which returns `this`), so the reverse patch doesn't apply. I re-added an override `IncomingMessage.prototype.destroy = function destroy(error) { Readable.prototype.destroy.call(this, error); };` that delegates but discards the return value, restoring the old behaviour of returning `undefined`.

**Failing test:** `parallel/test-http-incoming-message-destroy` — `not ok`, AssertionError: actual `undefined`, expected the `IncomingMessage` instance. Stable across 2 runs.
