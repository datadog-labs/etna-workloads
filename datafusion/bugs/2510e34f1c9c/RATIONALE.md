# Rationale

Fix hunk: in `pushdown_limit_helper` the "add fetch or a LimitExec" path no longer sets
`global_state.satisfied = true` when a child already has a limit, because that flag made the
child's own limit get dropped (issue #14204).

In 55.2.0 that exact hunk's guard is not present, but the child-limit case is covered by a second
path: when a limit node is extracted, `global_state.satisfied = false` resets the flag inherited from
the parent. That reset is what keeps a child limit from being dropped.

## Change
`datafusion/physical-optimizer/src/limit_pushdown.rs`: removed `global_state.satisfied = false;`
from the `extract_limit` branch. A child limit now inherits `satisfied = true` from an ancestor that
already materialised a limit, so it is removed and never re-added. That is the defect the fix's
guard prevented (children limits "overridden" by the satisfied flag).

## Oracle
`limit.slt` fails: the existing query at line 718 (join of two `ORDER BY .. OFFSET 1 LIMIT 4` subqueries
with outer `OFFSET 3 LIMIT 2`) returns wrong rows (`3 99 79 / 3 98 89` instead of `3 98 79 / 3 97 96`),
because inner limits are dropped. sqllogictest stops at the first failure, so the added
cross-join subquery cases (#14204) are not reached, but they exercise the same mechanism.
