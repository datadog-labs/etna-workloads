# Rationale

Fix hunk: `src/expr.c` `impliesNotNullRow()` gained `case TK_IN:` in the list of
operators that return `WRC_Prune`. Before the fix, IN fell into the default case, so
the walker descended into the right-hand list and treated a column of the LEFT JOIN
table appearing there (e.g. `a IN (1,3,x,y)`) as proof that the row is non-null.
That is a false positive, and the LEFT JOIN was wrongly reduced to an inner join.

In 3.54.1 the IN logic is a dedicated `case TK_IN:` block. It walks only `pLeft` and
then prunes, so the RHS is never inspected. I removed that block. IN now falls to
`default: WRC_Continue`, the pre-fix behaviour, and the walker visits the RHS list.

Oracle: `test/join.test` `join-15.105` fails. The LEFT JOIN is wrongly strength-reduced
and the expected `1 2 {} {} x 3 4 {} {} x` is not returned. The other 198 cases pass.
