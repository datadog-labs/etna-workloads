# Rationale

Hunk: src/src/backend/executor/execParallel.c, ExecParallelFinish / ExecParallelCleanup
(fix.patch hunks "Finish parallel execution" and "Accumulate instrumentation, and then clean up").

The fix moved the ExecParallelRetrieveInstrumentation() call from ExecParallelFinish to
ExecParallelCleanup. I moved it back into ExecParallelFinish (after buffer/WAL accumulation).
Finish can run on every rescan, so worker instrumentation is accumulated repeatedly instead
of once at final cleanup.

Not reverted: the ExecHash/ExecSortReInitializeDSM removal (those functions no longer exist in
the current tree; the core accumulation regression is sufficient).

Failing oracle case: src/test/regress||select_parallel
