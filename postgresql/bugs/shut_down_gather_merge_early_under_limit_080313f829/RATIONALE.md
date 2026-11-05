# Rationale
- File/function: src/backend/executor/nodeLimit.c, ExecLimit (LIMIT_INWINDOW, end-of-window branch under LIMIT_OPTION_COUNT).
- Traces to the nodeLimit.c hunk of fix.patch, which removed the early `ExecShutdownNode(outerPlan)` and added a comment. I re-added the call, guarded by `!(es_top_eflags & EXEC_FLAG_BACKWARD)`.
- Why it brings back the bug: Gather/Gather Merge under Limit are shut down as soon as the limit is reached. That destroys the parallel context, which rescans need, and it also loses worker instrumentation.

Failing oracle case: src/test/regress||select_parallel (expected; see the oracle run).
