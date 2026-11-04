# Rationale

Fix hunk (nth_value.rs): with IGNORE NULLS, when the array has no null buffer the
computed `valid_indices` was empty and the old code returned a NULL result, instead
of treating it as `None` and falling through to the normal (non-null-aware) path.

In 55.2.0 the code was rewritten: `NthValueEvaluator::valid_index` only takes the
null-aware path when `nulls.null_count() > 0`. I re-expressed the pre-fix behaviour
there: with `ignore_nulls` and no null buffer (`slice.nulls() == None`) it now
returns `None` (=> NULL result) rather than falling through to the plain
first/last/nth computation.

Oracle: window.slt fails (first reported at line 741, 40+ further diffs): any
`first_value/last_value/nth_value ... IGNORE NULLS` over a null-free column returns
NULL, including the fix's added case `nth_VALUE(column1, 1) IGNORE NULLS OVER(ORDER BY column2)`.
