# Rationale

File: src/planner/binder/query_node/plan_subquery.cpp, `PlanExtremumRewrite`

1. Hunk 1 (fix: skip PushCollation for BIT/VARIANT): restored the unconditional
   `ExpressionBinder::PushCollation(binder.context, min_max_child, compare_type);`.
   min/max's own collation branch becomes a no-op for BIT/VARIANT, so the binary-key
   implementation is chosen and returns BLOB.
2. Hunk 2 (fix: reference aggregate by its real type): removed `extremum_type` and
   built `extremum_ref` with `child_type` again. The column ref type (VARIANT/BIT)
   then mismatches the aggregate's BLOB output, giving
   "Failed to bind column reference "": inequal types (VARIANT != BLOB)".

Oracle: test/sql/subquery/any_all_variant_extremum.test should fail (see etna-check result below).

## etna-check result
FAIL     test/sql/subquery/any_all_variant_extremum.test
         Query unexpectedly failed (test/sql/subquery/any_all_variant_extremum.test:11)
         SELECT 127::INTEGER::VARIANT >= ALL (SELECT v FROM v);
         INTERNAL Error: Failed to bind column reference "" [14.0]: inequal types (VARIANT != BLOB)
1 of 1 oracle units fail
