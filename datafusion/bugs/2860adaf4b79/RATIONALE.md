# Rationale

Both fix hunks still apply in spirit to `datafusion/physical-optimizer/src/limit_pushdown.rs` (`pushdown_limit_helper`); I reverted both.

1. Bug 1: fix added `global_state.satisfied = false;` when an inner limit is extracted. Removed that line in the `extract_limit` branch. A nested limit that is removed no longer resets `satisfied`, so it may not be re-inserted.
2. Bug 2: fix changed `if global_state.fetch.is_none()` to `if global_state.skip == 0` before setting `satisfied = true` for a node with fetch. Restored `global_state.fetch.is_none()`, so a skip-only limit is wrongly treated as satisfied by a fetch-capable node and gets dropped.

## Oracle failures
- limit.slt: the OFFSET/LIMIT join query returns `3 99 79 / 3 98 89` instead of `3 98 79 / 3 97 96`.
- union.slt: the plan lacks the `GlobalLimitExec: skip=0, fetch=3` nodes the fix added. The same file also shows a `CAST(1 AS Int64)` diff in the plan output.
