# Rationale

Hunk: src/optimizer/statistics/operator/propagate_join.cpp, `StatisticsPropagator::HandleJoinNeverMatches`.
Traces to the fix's hunk replacing the old RIGHT_ANTI/ANTI case. In today's code the fix lives in
`LogicalJoin::PromoteJoinSide(child, projection_map)`; I reverted the two call sites to the pre-fix
behaviour: swap children for RIGHT_ANTI, then `node_ptr = std::move(join.children[0])`, dropping
left/right_projection_map. The output layout then no longer matches what parents bind to (issue #26000),
giving wrong results/errors in test_anti_join_projection_map.test.

Oracle: test/sql/optimizer/plan/test_anti_join_projection_map.test (see etna-check output below).

## etna-check
```
FAIL     test/sql/optimizer/plan/test_anti_join_projection_map.test
         ...:20  SELECT count(DISTINCT p.q) FROM p ANTI JOIN x ON p.r = x.w JOIN y ON p.s = y.w2;
         INTERNAL Error: Failed to bind column reference "q" [0.2] (bindings: {#[2.0], #[0.1]})
1 of 1 oracle units fail
```
