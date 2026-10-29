# Rationale

## Changed hunk
`src/select.c`, `sqlite3SelectCheckOnClauses()`: the check loop over table-valued
function arguments tested `jointype & (JT_LTORJ|JT_RIGHT)`; it now tests only
`jointype & JT_RIGHT`.

Reverses the fix hunk that changed `JT_OUTER` to `JT_OUTER|JT_LTORJ` in the same loop.
In 3.54.1 that loop was rewritten (it now uses `JT_LTORJ|JT_RIGHT`), so the fix could not be
reversed literally. Dropping `JT_LTORJ` restores the pre-fix behaviour: a table-valued function
on the left of a RIGHT JOIN has its arguments left unchecked, so references to tables to its
right are silently accepted.

The other fix hunks (`iJoin` sentinel change, the `sqlite3ProcessJoin` condition) are not
needed here, because the current code already covers them through different logic.

## Oracle failures
tabfunc01-1602 and tabfunc01-1603 fail. They expect the error
"table-function argument references tables to its right" but get `0 {1 2 3}` and `0 {}`.
