# Re-introduced bug: events.once leaks 'error' listener on abort

**Bug:** When `events.once(emitter, name, { signal })` is aborted, the abort handler tried to remove the `'error'` listener but passed the wrong function (`resolver` instead of `errorListener`), so the `'error'` listener stayed on the emitter after the abort.

**Hunk (lib/events.js, `abortListener` inside `once`):** corresponds to the single implementation hunk of the fix. The line `eventTargetAgnosticRemoveListener(emitter, 'error', errorListener)` is changed back to `... 'error', resolver)`. The code now uses `AbortError` rather than `lazyDOMException`, but the line is the same. `resolver` was never registered for `'error'`, so the removal does nothing.

**Failing test:** `parallel/test-events-once` fails (`not ok`) on 2 of 2 runs. The assertion that fails is `strictEqual(ee.listeners('error').length, 0)` from `abortSignalRemoveListener`, with `actual: 1, expected: 0`. That test is in the upstream fix, but this tree's copy of the test file already contains it.
