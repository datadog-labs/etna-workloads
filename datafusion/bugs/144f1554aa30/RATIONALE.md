# Rationale

## Hunk 1: `simplify_predicates.rs::find_most_restrictive_predicate`
Reverses the whole fix hunk. The `op` binding goes back to `op: _`, and the
`|| (comparison == Equal && op == Gt / Lt)` tie-breaks are removed. On equal
boundaries the first predicate wins regardless of strictness. So `x >= 1` can
displace or shadow `x > 1`, and `x <= 10` can displace or shadow `x < 10`.
That is the pre-fix behaviour.

## Hunk 2: `push_down_filter.rs` (Filter over Filter merge)
Reverting hunk 1 alone does not reproduce the bug on 55.2.0. The merge of a
filter with its child filter now puts the child's predicates first ("Child
filters first to preserve execution order"). The strict predicates from the
inner filter then come first, and "first wins on ties" happens to keep them.
At fix time the outer filter's predicates came first, which is what exposed
the bug. I restored that order (outer predicates, then child predicates), so
the tie is again resolved in favour of the non-strict outer predicate. This
is a second path that masked the same defect. It is not a separate fault: the
bug only shows when the weaker operator comes first on a tie.

## Oracle
`simplify_predicates.slt` fails on its one new case. The plan shows
`int_col >= 1 AND int_col <= 10` where `int_col > 1 AND int_col < 10` is
expected. The non-strict bounds are wrongly kept, so the filter is looser
than the query's actual constraints.
