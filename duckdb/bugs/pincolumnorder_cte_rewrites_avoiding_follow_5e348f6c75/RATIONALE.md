# Rationale

The fix added `AggregateRewriteHelper::PinColumnOrder`. In today's code the same pinning is done inline with
`LogicalProjection::CreateIdentity(...)`. I undid the fix by removing the pinning projection at each of the three call sites.

1. `src/optimizer/grouping_sets_optimizer.cpp`, `TryExpandGroupingSets`: the CTE definition is `op->children[0]` again, with no projection. This traces to the fix's grouping_sets_optimizer.cpp hunk.
2. `src/optimizer/multi_stage_aggregate_rewriter.cpp`, `CreateRewriteBranch`: removed the projection in the `input_consumers > 1` branch. This traces to the fix's CreateRewriteBranch hunk.
3. `src/optimizer/multi_stage_aggregate_rewriter.cpp`, `MultiStageAggregateRewriter::TryRewrite`: removed the projection of `op->children[0]` in the `needs_cte` branch. This traces to the fix's TryRewrite hunk.

Without the projection, the CTE definition exposes the child's raw column order. Later optimizations such as join reordering can change that order, so the CTE references no longer match it.

## Oracle result
See the etna-check output below.

etna-check output:

    Query unexpectedly failed (test/sql/aggregate/distinct/rewrite/distinct_aggregate_rewrite_join_order.test:11)
    1 of 1 oracle units fail
