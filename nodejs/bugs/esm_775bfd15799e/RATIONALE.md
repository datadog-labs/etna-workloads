# Re-introduced bug: `process.exit()` in ESM entry point exits with code 13

**Bug.** While an ESM entry point's promise (which may contain top-level await) is pending, an `'exit'`
listener sets `process.exitCode ??= 13`. `process.exit()` with no argument emits `'exit'` without having set
an exit code, so the listener fires and the process exits with 13 instead of 0 (nodejs/node#40808).

**Fix hunks and how they are re-expressed.** The fix (a) moved the handler into
`esm/handle_process_exit.js`, (b) used it in `run_main.js`'s `handleMainPromise`, and (c) made
`process.exit()` in `per_thread.js` call `process.off('exit', handleProcessExit)` first. In v26.13.0
`handleMainPromise` no longer exists (unsettled TLA is detected in C++), and `per_thread.js` has no such
`off` call, so (c) is already absent, which is the buggy state.
- `lib/internal/modules/run_main.js`: add `handleProcessExit` (`process.exitCode ??= 13`) and
  `handleMainPromise` (registers the `'exit'` listener while the entry promise is pending, removes it in
  `finally`). `runEntryPointWithESMLoader` wraps the entry promise with it. This matches the pre-fix
  `handleMainPromise` hunk. Nothing is done in `process.exit()` to remove the listener, so it stays
  active, which is the bug.
- An initial attempt in C++ (`ReallyExit`) was abandoned and reverted. The entry promise isn't registered
  yet when `process.exit()` runs synchronously in the module body.

**Failing test.** `es-module/test-esm-tla-unfinished` fails on "should exit successfully when calling
`process.exit()` in `.mjs` file" with `actual: 13, expected: 0`. `parallel/test-bootstrap-modules` still
passes (no new module is added). I ran it twice and the failure was stable.
