# Rationale

## Change
`tree/datafusion/functions-aggregate/src/string_agg.rs`: removed the
`reverse_expr` override from `impl AggregateUDFImpl for StringAgg`.

This reverses the fix's only implementation hunk, which added
`reverse_expr` returning `ReversedUDAF::Reversed(string_agg_udaf())`. In 55.2.0
the method is still present at the same spot, so deleting it restores the
pre-fix code. The trait default is `ReversedUDAF::NotSupported`.

## Oracle failures
`aggregate.slt` fails. With `string_agg(k, ',' order by v)`, the physical plan
has no `SortExec`, so the ORDER BY is not honoured and the results are wrong.
The two-invocation (ASC and DESC) explain also lacks the expected single
`SortExec`.
