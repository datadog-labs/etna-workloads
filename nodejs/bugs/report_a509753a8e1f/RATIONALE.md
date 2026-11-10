# Re-introduced bug: report without isolate has no javascriptStack section

**Bug.** Before upstream fix a509753, `WriteNodeReport` only wrote the `javascriptStack` section when an isolate existed. Reports from threads without an isolate (e.g. an addon calling `node::TriggerNodeReport` with no isolate) therefore lacked the section entirely, and consumers reading `report.javascriptStack.message` hit `undefined`.

**Hunks.**
1. `src/node_report.cc`, fix hunk 2 (the `else` branch after `if (isolate != nullptr)` that writes an empty `javascriptStack`): removed again. This restores the old behaviour.
2. Fix hunk 3 (`!isolate->InContext()` in `PrintJavaScriptStack`): not reverted. In this release the check lives in the shared helper `GetCurrentStackTrace` (`src/node_errors.cc`), which other callers rely on. Removing it would cause unrelated breakage or crashes. The fix's first hunk, which only added a forward declaration, is not needed.

**Failing test.** `addons/report-api/test` fails with `not ok 1`: `AssertionError [ERR_ASSERTION]: The expression evaluated to a falsy value` (and a TypeError on `content.javascriptStack.message` for the no-isolate cases). It failed on both runs.
