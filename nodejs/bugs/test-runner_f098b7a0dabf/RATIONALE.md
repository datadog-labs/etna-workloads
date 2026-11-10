# Rationale
Bug: errors thrown asynchronously from test hooks (before/beforeEach/after/afterEach) were not recognised as hook errors in the process uncaughtException/unhandledRejection handler (`lib/internal/test_runner/harness.js`). The diagnostic was a "Warning: Test ... generated asynchronous activity" message without the hook type or source location.

Hunks (all in harness.js, re-expressed for today's code):
1. Removed `const { relative } = require('path')` (fix hunk 1) – no longer needed.
2. Condition `!test || test.finished || test.hookType` -> `!test || test.finished` (fix hunk 2): hook errors fall through to test.fail()/abort instead of being reported as diagnostics.
3. Message restored to `Warning: Test "<name>" generated ...` without hook name / `at file:line:col`, and `Warning: A resource ...` (fix hunk 2 message part).

Failing test: parallel/test-runner-extraneous-async-activity — assertion that stdout matches `# Error: Test "extraneous async activity test" at ...` fails (output has `# Warning: Test ...` without location). Stable across two runs.
