# Rationale

Changed only src/src/planner/subquery/flatten_dependent_join.cpp (header untouched to avoid a long rebuild).

1. `FlattenDependentJoins::AddCTERefJoinConditions` — undoes the hunk that made it use the precomputed
   `positions` (binding-based mapping). Restored the old body: it re-derives the CTE correlated columns itself and
   silently returns when CTE metadata is missing. The `positions` parameter is kept in the signature but ignored.
2. `FlattenDependentJoins::PushDownCTERef` — undoes the hunk that built the state from `GetCTERefCorrelatedPositions`.
   Restored the old logic: if the ref has fewer correlated columns than required, join with a DelimGet; otherwise
   assume the CTE ref's correlated columns are contiguous at the end and in the same order as `correlated_columns`
   (positional, not by column binding). `GetCTERefCorrelatedPositions` is now unused.

## Oracle
`1 of 1 oracle units fail` — test/sql/cte/recursive_cte_correlated_bindings.test, e.g.
`INTERNAL Error: Failed to bind column reference "b" [23.1]: inequal types (STRUCT(y INTEGER) != STRUCT(x INTEGER))`
