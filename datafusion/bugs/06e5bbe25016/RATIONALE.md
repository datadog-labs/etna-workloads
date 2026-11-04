# Rationale

File: `datafusion/physical-optimizer/src/ensure_requirements/enforce_sorting/sort_pushdown.rs`
(moved from `enforce_sorting/sort_pushdown.rs` in the fix).

55.2.0 still contains the fix's guard at the top of `pushdown_requirement_to_children`.
I removed it, restoring the pre-fix behaviour:

- Hunk "if parent_fetch.is_some() && !plan.supports_limit_pushdown() { return Ok(None) }" removed.
- Hunk "if parent_fetch.is_some() { match plan.cardinality_effect() { Equal => {}, _ => return Ok(None) } }" removed.
- The `CardinalityEffect` import, which is no longer used, was removed (fix hunk 1).
- The `parent_fetch` parameter was renamed `_parent_fetch`. The fix added that parameter, and the pre-fix function did not have it. I kept it so the call sites still compile.

A TopK (sort with fetch) can again be pushed below operators that change cardinality, such as a hash join (anti join) or a UnionExec.

## Oracle failures
- `union.slt`: the plan has a TopK pushed into the UnionExec branch, so the EXPLAIN output differs.
- `topk.slt`: `select * from (select * from topk limit 8) order by x limit 3` returns different rows.
- joins.slt, limit.slt and order.slt were not reported as failing by check.sh. Only topk.slt and union.slt are listed above.
