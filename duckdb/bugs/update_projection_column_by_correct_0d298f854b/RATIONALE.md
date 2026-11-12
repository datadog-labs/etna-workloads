# Rationale

Bug: expression pushdown optimizers update `projection->types[...]` using the LogicalGet column index
instead of the index of the column within the wrapping LogicalProjection.

Hunks changed (src/src/optimizer/):
- type_pushdown.cpp, `CastReplace::VisitReplace(BoundColumnRefExpression&)` and `(BoundFunctionExpression&)`:
  `projection->types[projection_column_index]` -> `projection->types[column_index]`
  (traces to the fix's same two hunks).
- scalar_fn_pushdown.cpp, `ScalarFnReplace::VisitReplace` (both overloads): same change.

The fix's additional hunks (header field `projection_column_index`, `Resolve`, and the multi_file_function
FinalizeScan change) are not reverted: the header change would force a huge rebuild, and the field simply
becomes unused (the structured binding still compiles). Only the wrong-index behaviour is restored.
The multi_file hunk is unrelated to this test.

Oracle result: see check.txt in this directory (output of ./bin/etna-check).

Oracle output (etna-check):
```
FAIL     test/optimizer/pushdown/type_pushdown_projection_index.test
         Query unexpectedly failed (...:13)
         INTERNAL Error: Attempted to access index 2 within vector of size 1

1 of 1 oracle units fail
```
