# Rationale

Fix: concat stopped claiming `preserves_lex_ordering`.

## Hunk changed
- `datafusion/functions/src/string/concat.rs`: re-added
  `ScalarUDFImpl::preserves_lex_ordering` for `ConcatFunc` returning `Ok(true)`
  (plus the `ExprProperties` import). This reverses the fix's removal of that
  method. It is the same code, since the trait default is `false`.

The doc-comment hunks (`sort_properties.rs`, `udf.rs`) and the unit-test changes
in the fix are not behavioural and were left alone.

## Oracle failures
`monotonic_projection_test.slt` fails. The optimizer treats `concat(a, b)` as
ordered by `(a, b)`, so:
- the `ORDER BY a, b` plan over `c = concat(a, b)` drops the required SortExec,
  and the query returns `a0 1` before `a 1`;
- the `concat(a, b) ORDER BY c` plan and its result also mismatch.
