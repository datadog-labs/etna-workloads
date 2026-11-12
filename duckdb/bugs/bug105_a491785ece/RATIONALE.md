# Rationale
File: src/src/function/scalar/system/aggregate_export.cpp. Two hunks, both removing the `argument_count > column_count` BinderException (the fix's added check).
1. `BindAggregateStateInternal`: removed the check added by the fix (exactly the fix hunk).
2. `to_aggregate_state` bind (ordered-state branch): today's code has a duplicate of the same check (`aggr_arguments.size() > column_count`) that fires first with the identical message; it had to be removed too for the bug to resurface.

Result: argument count 2 with 1 buffered column is no longer rejected with a Binder Error; it proceeds to an out-of-bounds access.

etna-check:
FAIL test/sql/aggregate/aggregate_state_export/test_sorted_aggregate_state_bounds.test:6
INTERNAL Error: Attempted to access index 1 within vector of size 1
1 of 1 oracle units fail
