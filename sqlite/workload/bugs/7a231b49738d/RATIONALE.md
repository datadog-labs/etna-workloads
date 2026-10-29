# Rationale

## Hunk changed: `exprImpliesNotNull()` in `src/expr.c`, `case TK_BETWEEN`
Reverses the fix's only implementation hunk. The fix changed the three
recursive calls for the BETWEEN operands (`a[0]`, `a[1]` and `pLeft`) from
passing `seenNot` to passing a constant `1`. I restored `seenNot` in all three.
The surrounding code has been refactored (const-qualified params, etc.), but
the BETWEEN case is otherwise identical to the pre-fix code.

With `seenNot` passed through, `(X IS FALSE) BETWEEN FALSE AND TRUE` is
analysed with seenNot=0 at the TK_TRUTH node. The `IS FALSE` is then wrongly
taken to imply X is not NULL, so the partial index `WHERE c0 NOT NULL` is
used for a row where c0 is NULL and the row is missed.

## Oracle failures
`./check.sh`: index6-15.2, index6-15.3 and index6-15.4 fail. These are the
BETWEEN cases the fix added (the operand, lower bound and upper bound
positions). Each returns no rows instead of `1`.
