# Re-introduced bug: process.config writable (reverts e0ab8dd637)

**Bug:** `process.config` (and its nested objects) were mutable. Assigning `process.config.variables = 42` silently succeeds (at most a DEP0150 deprecation warning) instead of throwing a TypeError, because the config was wrapped in a deprecation Proxy and exposed via getter/setter.

**Change (lib/internal/bootstrap/node.js only):**
- Hunk 1 (imports): restore `ObjectPreventExtensions`, `ReflectGet`, `ReflectSet`; drop `ObjectFreeze` (fix removed the former and added the latter).
- Hunk 2: replace the frozen-via-reviver `JSONParse` and the data property `value: processConfig` with the old `deprecationHandler` Proxy, `let processConfig`, and getter/setter on `process.config`. This brings back the writable, warn-only behaviour.

**Failing test:** `parallel/test-process-config` — the assertion `assert.throws(() => { process.config.variables = 42; }, TypeError)` fails (no exception thrown). `abort/test-abort-fatal-error` still passes (the fix's change there only tweaked heap flags in the test, unrelated to implementation).
