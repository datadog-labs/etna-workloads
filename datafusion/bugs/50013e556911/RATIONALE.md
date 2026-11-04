# Rationale

Fix hunk reversed: in `extract_non_nullable_columns`, the fix merged `IS TRUE`, `IS FALSE` and
`IS NOT UNKNOWN` into the `IsNotNull` arm so they only recurse when `top_level`. Before the fix they
had their own arm that recursed unconditionally.

In 55.2.0 the logic is `extract_null_rejecting_sides` in `datafusion/optimizer/src/eliminate_outer_join.rs`.
I split `IsTrue | IsFalse | IsNotUnknown` back out of the `IsNotNull` arm. `IsNotNull` keeps its
`top_level` guard, as before the fix. The three operators now recurse at any depth. This is the same
defect, because nested `NOT (x IS TRUE)` is treated as null-rejecting. I did not revert the other
fix changes (`returns_null_on_null`, `Negative`, the OR rewrite).

Oracle: `eliminate_outer_join.slt` fails on 6 queries, the explain and result checks for
`NOT (.. IS TRUE)`, `NOT (.. IS FALSE)` and `NOT (.. IS NOT UNKNOWN)`. The LEFT JOIN is wrongly turned
into an inner join, so the NULL-padded rows are missing from the results.
