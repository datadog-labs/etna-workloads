# Rationale

File: src/function/aggregate/distributive/minmax.cpp

1. `MinMaxUsesCollation` (the code the fix's first hunk touched in `BindMinMax`): removed `nested_collation`
   (STRUCT/LIST/ARRAY) from the collation condition, so min/max on nested types no longer goes through the
   collated arg_min/arg_max path and ignores field collations.
2. `BindMinMax`: removed `function.GetArguments()[1] = arguments[1]->GetReturnType();` (second hunk).

Oracle: test/sql/collate/collate_struct_minmax.test should fail (min/max of struct/tuple with NOCASE field
returns binary-order result, e.g. max = (a, 0) instead of (B, 0)). Result lines: see below.

## etna-check output
FAIL     test/sql/collate/collate_struct_minmax.test
         Wrong result in query! (test/sql/collate/collate_struct_minmax.test:13)
         Mismatch on row 1: (a, 0) <> (B, 0)
1 of 1 oracle units fail
