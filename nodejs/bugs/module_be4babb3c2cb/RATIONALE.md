# Bug
When the CJS loader detects an ambiguous `.js` entry point is ESM (loadESMFromCJS), it runs the import via runEntryPointWithESMLoader but the callback did not return the import promise. The entry-point runner therefore could not await it, so an unfinished top-level `await` was not reported (exit code 0 instead of 13).

# Change
lib/internal/modules/cjs/loader.js, loadESMFromCJS: `return cascadedLoader.import(...)` -> `cascadedLoader.import(...)` (corresponds to the sole implementation hunk of the fix; the call has an extra argument in today's code).

# Failing test
es-module/test-esm-detect-ambiguous: "reports unfinished top-level `await`" fails with AssertionError: Expected values to be strictly equal (actual: 0, expected: 13). Failed in two consecutive runs.
