# Rationale

Hunk: `src/parallel/task_executor.cpp`, `TaskExecutorTask::Execute` (cancel branch).
Traces to the fix's `TaskExecutorTask::Execute` / `BaseExecutorTask::Cancel` hook: "Cancel is the hook for a task
retired without running". The bug brought back: when the executor has an error or is cancelled, the wrapper retires
the task (counter still settled by FinishGuard) but no longer calls `task->Cancel()`, so anything a waiter watches
(e.g. the COPY lifecycle job in `WaitForJob`, or tests counting Cancel calls) is never settled.

Oracle results: see etna-check output (appended below if available).

etna-check (exit 0, 2 of 6 oracle units fail; the other 4 still pass with this single-hunk bug):
```
FAIL cpp:test/api/test_partial_executor.cpp::TaskExecutor runs exactly one of ExecuteTask or Cancel for every scheduled task
     executed + cancelled == TASK_COUNT 40 == 64
FAIL cpp:test/api/test_partial_executor.cpp::TaskExecutor drains batch execution and cancellation failures
     counts->cancelled == 63 0 == 63 | counts->cancelled == 64 0 == 64 | executor.HasError() false
```
