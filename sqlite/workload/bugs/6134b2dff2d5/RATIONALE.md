# Rationale

Fix: "continue"/"break" from inside the loop of the right operand of a RIGHT JOIN
(the fix resolved `pLevel->addrCont` at the OP_Return that ends the RIGHT JOIN
subroutine, so "continue" jumps to the Return rather than past it into the
loop-advance code).

In 3.54.1 that logic lives in `sqlite3WhereEnd()` (src/where.c), in the `pLevel->pRJ`
block. It resolves `addrCont` at the end of the subroutine, then replaces it with a
fresh never-used label so the later generic resolve has something to resolve. This is the
descendant of the fix hunks (resolve addrCont before OP_Return; set it to 0 and skip the
later resolve).

Change: removed the early `sqlite3VdbeResolveLabel(addrCont)` and the replacement
`sqlite3VdbeMakeLabel`. addrCont is now resolved at the normal loop-advance point after the
Return, as before the fix, so "continue" skips the Return and runs the loop's Next.

Oracle failure: where-18.1rj aborts with assertion `pOp->p1!=SQLITE_INTERNAL` in
sqlite3VdbeExec (the following join7 / where-18.*rj cases do not run).
