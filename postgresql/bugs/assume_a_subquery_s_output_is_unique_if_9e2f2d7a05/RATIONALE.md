# Rationale

File: src/backend/optimizer/plan/analyzejoins.c

Traces to the single fix.patch hunk in pathnode.c `query_is_distinct_for()`, which added
`if (expression_returns_set(query->targetList)) return false;`. The code has since moved to
analyzejoins.c and expresses that check as `query->hasTargetSRFs`, in two places. I removed both:

1. `query_is_distinct_for_with_collations()`: removed `if (query->hasTargetSRFs) return false;`
   (the SRF safety check before the GROUP BY / aggregate / set-op uniqueness proofs).
2. `query_supports_distinctness()`: removed the matching early "SRFs break distinctness" pre-check.
   It would otherwise still reject such subqueries.

With both removed, a subquery with an SRF in its tlist plus GROUP BY, aggregates or set ops is
again assumed unique. The planner can then wrongly drop a join's uniqueness handling or build a
unique-ified path, which gives wrong results. The original bug returned duplicate rows.

Oracle case expected to fail: src/test/regress||subselect
