# Rationale

## Change
`datafusion/expr/src/utils.rs`, `can_hash`: `DataType::Utf8View` now returns `false` (the fix added `DataType::Utf8View => true`).
In 55.2.0 the match is exhaustive, so removing the arm would not compile. An explicit `Utf8View => false` arm gives the pre-fix result, since the old wildcard-style fallthrough was `false`.

`can_hash` is used by `extract_equijoin_predicate`, `eliminate_cross_join` and the plan builder, so a Utf8View join key is no longer recognised as an equijoin key.

## Oracle
`joins.slt` fails. The Utf8View join (`natural join` on a Utf8View key) and other plans in the file now plan a `NestedLoopJoinExec` with a filter in place of a `HashJoinExec`. The failure is a plan mismatch at joins.slt:4681 (2 failures in total).
