# Rationale

Fix hunk reversed: `src/whereexpr.c`, `sqlite3WhereTabFuncArgs()`. I removed the
`if( !IsVirtual(pTab) ){ sqlite3ErrorMsg(... "'%s' is not a function" ...); return; }`
block, which restores the pre-fix code. A CTE or other non-virtual table used
as a table-valued function in the recursive part of a CTE is no longer
rejected here.

Fix hunk not reversed: the `assert( IsVirtual(pRightTab) )` removal in
`src/select.c`. The fix removed an incorrect assert, so putting it back would
add a fault the fix did not remove. It is also absent from the current tree.
The `cannotBeFunction()` path in `select.c` is unchanged. It covers the other
cases but not this one.

Oracle case that fails: `with1-29.1`. It expects `'cte1' is not a function`
and gets `too many arguments on cte1() - max 0`. The CTE is still rejected, but
by a later error path with a different message. The test fails on the wrong
error text, not on a crash or wrong rows.
