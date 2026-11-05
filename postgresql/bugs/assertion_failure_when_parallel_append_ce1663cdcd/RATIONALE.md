# Rationale

Hunk: src/backend/executor/nodeAppend.c, choose_next_subplan_locally().
Traces to the fix.patch hunk in choose_next_subplan_locally, which removed the Assert forbidding INVALID_SUBPLAN_INDEX and added handling for it when a parallel-aware Append runs serially.
In current code the INVALID_SUBPLAN_INDEX handling is already folded into the bms-based logic, so the bug is re-expressed as the range Assert rejecting INVALID_SUBPLAN_INDEX (-1) for parallel_aware plans. A Parallel Append run serially (as_whichplan starts at INVALID) hits the assertion.

Failing oracle case: src/test/regress||select_parallel
