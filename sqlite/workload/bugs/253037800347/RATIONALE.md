# Rationale

Fix (ticket #980): expressions in UPDATE/INSERT with BEFORE triggers were
evaluated twice (once for NEW.* seen by the trigger, once for the real write);
the fix added sqlite3ExprCodeAndCache() so each is evaluated once.

In 3.54.1 each SET expression is evaluated once into the regNew registers,
which triggers read and the write uses, so there is no cache helper to remove.
The only way to get double evaluation is to evaluate again.

## Change (src/update.c, the "After-BEFORE-trigger-reload-loop")
After a BEFORE UPDATE trigger fires, the loop reloads unmodified columns. I
added a branch that also re-runs `sqlite3ExprCode()` on the SET expression of
each modified column into its register. This reverses the fix's update.c hunk
(`sqlite3ExprCodeAndCache` -> plain `sqlite3ExprCode` per SET expression):
the expression is evaluated once for the trigger's NEW.* and again for the
row actually written. The INSERT hunk was not reverted. Its path already
evaluates once into regCols.

## Oracle
trigger6-1.5 fails: `UPDATE t1 SET y=counter(5)` stores 4 but the trigger log
holds 3 (expected `2 3`, got `2 4`). Other cases still pass.
