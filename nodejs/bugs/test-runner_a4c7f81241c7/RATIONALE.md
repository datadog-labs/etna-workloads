# Re-introduced bug: reporter errors not rethrown (a4c7f81241c7)

**Bug:** Errors thrown by a custom test reporter (synchronously in the generator, or asynchronously via setImmediate) were swallowed by the test runner's uncaughtException handler and reported as a generic top-level diagnostic instead of crashing the process with the error.

**Changes (lib/internal/test_runner/harness.js only):**
1. Removed `testResources.set(reporterScope.asyncId(), reporterScope);` — corresponds to the fix's identical added line in harness.js. Without it, errors originating in the reporter's async scope are no longer mapped to the reporter.
2. Removed the `if (test === reporterScope) throw err;` check in `createProcessEventHandler` — corresponds to the fix's added check. Reporter errors now fall into the "no test" diagnostic path.

utils.js's `reporterScope` is left in place (the current code also uses it in `getTestContext`/setup, which postdate the fix).

**Failing test:** parallel/test-runner-reporters ("should throw when reporter errors" / "...asynchronously"): the child no longer exits with status 7 / emits the reporter error on stderr.
