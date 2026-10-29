# Rationale

## Change: src/expr.c, impliesNotNullRow()
Removed `case TK_TRUTH:` and its `testcase( pExpr->op==TK_TRUTH )` from the
group of operators that return WRC_Prune. This reverses the fix's two hunks
exactly. Without it, `(x IS FALSE)` / `(x IS TRUE)` nodes are walked into, so
the column inside is taken to imply a non-null row, and a LEFT JOIN gets
wrongly simplified to an inner join (a976c487).

## Oracle failures
test/join.test: join-18.2 and join-18.3 fail (the NOT(a IS FALSE) queries over
a LEFT JOIN return no rows instead of the row with a NULL).
