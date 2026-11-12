# Rationale

Fix hunk: `ListSelectFunction` in src/function/scalar/list/list_select.cpp now accesses the list child as a flat vector
(`FlatVector::Validity(input_entry)`), instead of the flatten-a-reference approach.

Today's code had already moved to `input_entry.Validity()` (a `VectorValidityIterator`, which tolerates non-flat vectors).
To bring back the original behaviour I changed (same file):
- `ListSelectFunction`: `auto input_validity = input_entry.Validity();` -> `auto &input_validity = FlatVector::Validity(input_entry);`
  (flat-only access; throws an internal error for a constant NULL child).
- `SetSelectionVectorSelect/Where::SetSelectionVector`: parameter type `const VectorValidityIterator &` -> `const ValidityMask &`
  and `IsValid(` -> `RowIsValid(`, needed to consume the flat mask.

The array_distance family part of the upstream fix lives in extension/core_functions (not editable here), so it is not touched.
The test's first query already fails via list_select/list_where.

## Oracle result
```
FAIL     test/sql/function/list/list_functions_constant_child.test
         Query unexpectedly failed (test/sql/function/list/list_functions_constant_child.test:6)
         INTERNAL Error: Operation requires a flat vector but a non-flat vector was encountered
1 of 1 oracle units fail
```
