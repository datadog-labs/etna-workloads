# Rationale

Fix hunk (src/window.c, `sqlite3WindowDup`): added `pNew->regResult = p->regResult;`.
Reversed by deleting that line in `tree/src/window.c` (same function still exists in 3.54.1, at the same spot between `eExclude` and `regAccum`).

Effect: a duplicated Window (e.g. when the LHS of `NOT BETWEEN` is a window function, so the expression gets duplicated) has `regResult==0`, so the expression reads register 0 instead of the window result.

Oracle: `window1-30.0` fails with `sqlite3VdbeExec: Assertion 'pOp->p3>0' failed` (assert/crash). Cases 1.0–29.2 still pass.
