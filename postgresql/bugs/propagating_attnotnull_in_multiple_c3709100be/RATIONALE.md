# Rationale

## src/backend/commands/tablecmds.c, ATExecSetNotNull()
Traces to the single fix_impl.patch hunk (a CommandCounterIncrement() making the attnotnull update visible before recursing to children, for multiple inheritance).
In current code set_attnotnull() no longer has the recursion. The recursion lives in ATExecSetNotNull(), whose child loop calls CommandCounterIncrement() before recursing into each child. I removed that call.
Without it, a child with several parents does not see the earlier parent's update, so attnotnull and the not-null constraint are not propagated correctly in multiple inheritance.

## Failing oracle cases
- src/test/regress||inherit

(src/test/regress||constraints still passes.)
