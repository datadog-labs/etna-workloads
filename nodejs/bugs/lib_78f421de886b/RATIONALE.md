# Bug
`safeTraceLabel` in lib/internal/util/debuglog.js escaped only backslashes in trace labels, not double quotes. A module specifier containing `"` produced invalid JSON in the trace output (module print timing / trace events).

# Change
lib/internal/util/debuglog.js, `safeTraceLabel`: removed `.replaceAll('"', '\\"')`, leaving `label.replaceAll('\\', '\\\\')`. This corresponds to the fix's single implementation hunk (today's code uses replaceAll for backslashes too), restoring the pre-fix behaviour.

# Failing test
parallel/test-module-print-timing: "not ok" on two consecutive runs (the test requires a file with `"` in its name while tracing; the trace output is then not valid JSON / lacks the expected events).
