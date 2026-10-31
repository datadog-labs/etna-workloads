# Rationale

Hunk reversed: `Python/instrumentation.c`, `branchesiter_next` — the fix's
added `case END_ASYNC_FOR:` (which reports the SEND/END_SEND source and the
not-taken/end destinations as a branch pair in `co_branches`). Removing it
restores the pre-fix state where the END_ASYNC_FOR branch pair is not part of
`co_branches()`, while sys.monitoring still emits BRANCH_RIGHT events for it
from INSTRUMENTED_END_ASYNC_FOR.

The other fix hunks (codegen, assemble, bytecodes, dis, flowgraph) were left
as is; only this one is needed to reintroduce the inconsistency.

Failing oracle case: `test.test_monitoring.TestBranchConsistency.test_async_for`
fails with `AssertionError: (42, 46) not found in set()` — the recorded branch
event is not in `co_branches`.
