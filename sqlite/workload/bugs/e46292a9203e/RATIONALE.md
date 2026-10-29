# Rationale

## State of version-3.54.1
The fix's `sqlite3ExprListDup()` / `exprDup()` hunks cannot be reversed: 3.54.1
already contains the pre-fix form of that code (`pPriorSelectColOld/New`,
`pNewExpr->pRight` test, no `assert(p->iColumn==0 || p->pRight==0)`).
The treeview hunk is diagnostic only. So reversing the fix there changes nothing.

## Change made (other path covering the same case)
`src/select.c`, in `sqlite3Select()`: removed
`p->selFlags &= ~(u32)SF_UFSrcCheck;` after the UPDATE...FROM
target-in-FROM check. The comment there says the flag must be cleared because a
compound sub-query flattened into the UPDATE...FROM query (UNION ALL
flattening) causes `sqlite3Select()` to be called again for the same select.
This is the later, independent guard for the fix's scenario: UPDATE on a
virtual table with `(a,a)=(SELECT ...) FROM t3` where t3 is a UNION ALL CTE that
is flattened. Without it the check is re-run on the flattened query.

This is not a crash like the original bug. It is a behavioural change in the
same scenario, and I did not reproduce the original crash.

## Oracle result
`vtab1-25.0` fails: expected `[0 {}]`, got
`[1 {target object/alias may not appear in FROM clause: t1}]`.
(That is the expectation in the oracle's test file, which differs from the
`fix.patch` hunk.) All other 215 oracle cases pass.
