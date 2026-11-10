# Re-introduced bug: missing test location for FileTest

**Bug:** `FileTest` instances (the per-file wrapper tests created by `run()`) had no `loc`, so `test:fail`/`test:pass` events for a file-level result (e.g. a timeout) reported `line`, `column` and `file` as undefined.

**Change:** `lib/internal/test_runner/runner.js` — removed the `FileTest` constructor body that did `this.loc ??= { line: 1, column: 1, file: resolve(this.name) }`. This corresponds to the fix's sole implementation hunk, which added that constructor. In today's code the constructor also sets `this.timeout = null`; I kept the constructor and only removed the `loc` assignment. The `resolve` import is still used elsewhere, so the fix's import hunk needed no reversal.

**Failing test:** `parallel/test-runner-filetest-location` now fails, because the `test:fail` event has no `line`, `column` or `file`. The `strictEqual(result.line, 1)` assertion fails. It failed on both runs.
