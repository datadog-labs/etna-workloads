# Re-introduced bug: asynchronously thrown errors swallowed by test runner

**Bug.** When an uncaughtException/unhandledRejection fires after a test has ended, the root-test handler in `lib/internal/test_runner/harness.js` only emits a diagnostic. The process then exits 0 and the error is effectively swallowed (the test is reported as passing).

**Hunk (lib/internal/test_runner/harness.js, `createProcessEventHandler`).** The fix added `process.exitCode = kGenericUserError;` after `rootTest.diagnostic(msg)`. In the current release that line is accompanied by `rootTest.harness.success = false;`, which also leads to a failing exit status through the summary. I removed both lines so the branch is just `rootTest.diagnostic(msg); return;`, as before the fix. Removing only the exitCode line was not enough (the test still passed).

**Failing test.** `parallel/test-runner-extraneous-async-activity` fails (stable over 2 runs): `actual: '✔ extraneous async activity test ...'`, `expected: /fail 1$/m`. `es-module/test-esm-repl-imports` still passes (its fix hunk was test-only).
