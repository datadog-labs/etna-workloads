# Rationale

## src/where.c, sqlite3WhereEnd()
Reverses the fix hunk that added, in the LEFT JOIN "no match" epilogue, a loop
emitting `OP_NullRow` on each IN-loop cursor (`WHERE_IN_ABLE`, `aInLoop[m].iCur`).
In 3.54.1 the block is written with an extra `eEndLoopOp!=OP_Noop` guard; I
removed the whole block, which restores the pre-fix behaviour (IN-loop
cursors are not nulled when the right operand of a LEFT JOIN has no match).

The `NEVER(pCur==0)` change in OP_IfNotOpen is an assert-coverage annotation
with no behavioural effect, so it was not reverted.

## Oracle failure
join2-14.0 fails: expected `1 NULL 5 NULL NULL NULL | 2 NULL NULL NULL NULL NULL |`,
got an extra spurious row `2 NULL NULL 1 NULL 5`, i.e. the right-hand table
row is not NULLed out for the null-extended LEFT JOIN row.
