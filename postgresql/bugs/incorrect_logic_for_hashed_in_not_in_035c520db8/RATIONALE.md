# Rationale

File: src/backend/executor/execExprInterp.c, function ExecEvalHashedScalarArrayOp (two hunks, both from the fix_impl.patch hunks in this function).

1. Removed the block (inside the hash-table build) that, for non-strict functions, linearly searched the array with a NULL LHS via ExecEvalArrayCompareInternal and cached null_lhs_isnull/null_lhs_result (fix hunk "@@ -4340,8 +4368,51 @@").
2. Removed the `if (scalar_isnull) {... return;}` early return that used the cached NULL-lookup result (same fix hunk).

Effect: a NULL LHS with a non-strict equality operator goes through the hash lookup, so a function that treats NULL as equal to some value is not honored, giving wrong IN / NOT IN results.
The helper function and struct fields are left in place (unused). Only the logic is reverted.

Failing oracle case: src/test/regress||expressions
