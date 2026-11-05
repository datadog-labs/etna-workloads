# Rationale

Both hunks are in `src/bin/pgbench/pgbench.c`.

1. `printResults()`, latency-limit line. This traces to the fix.patch hunk that changed that line to print `latency_late/ntx` with a guarded percentage. I reverted it to print only `latency_late`, with the percentage computed against `total_cnt`. `total_cnt` includes skipped transactions, so the percentage is wrong when some transactions are skipped. The `/ntx` part of the output is gone.
2. `printSimpleStats()`. This traces to the fix.patch hunk that added the `if (ss->count > 0)` guard. I removed the guard, so it divides by zero and prints NaN when no transactions were executed.

The `ntx` variable and the tps and progress-report hunks are not reproduced. Current code already counts `cnt` without skipped transactions, so there is nothing to revert there.

Failing oracle case:
- `src/bin/pgbench|t/001_pgbench_with_server.pl|pgbench late throttling stdout /(?^:above the 1.0 ms latency limit: [01]/)/`
