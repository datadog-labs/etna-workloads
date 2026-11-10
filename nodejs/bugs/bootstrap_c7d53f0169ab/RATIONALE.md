# Rationale

Bug: `node --help` wrote the help text directly to `process.stdout` with `stream.write`. If stdout is closed early (e.g. `node --help | head -n5`), the write fails with an unhandled EPIPE 'error' event and node exits non-zero with a stack trace. The fix printed via `console.log`, which swallows stream errors.

Change (lib/internal/main/print_help.js), one hunk corresponding to the fix's hunks:
- Removed `const console = require('internal/console/global');` (fix hunk 1 added it).
- Replaced `console.log(helpText)` with `stream.write(helpText + '\n')` (fix hunk 2 replaced `stream.write` calls with accumulated text + `console.log`). The release's accumulated-text structure is kept (styling code moved on since); only the output sink is reverted, which restores the EPIPE crash.

Failing test: parallel/test-cli-node-print-help — the closed-stdout section crashes the child with `Error: write EPIPE` (unhandled 'error' event), so the exit code is not 0 and the test is `not ok`.
