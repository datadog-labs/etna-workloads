# Rationale

Changed `tree/src/select.c`, in `sqlite3Select()`'s window-function block: the `selectInnerLoop()` call now passes `0` as `iBreak` instead of the `iBreak` label.

This reverses the fix's hunk `selectInnerLoop(..., iCont, 0)` -> `selectInnerLoop(..., iCont, iBreak)`. Before the fix, the inner-loop subroutine had no valid break target, so the LIMIT `OP_DecrJumpZero` / `OP_IfNot` jumped to address 0. The `iBreak` label and its `OP_Goto` are left in place. They are harmless on their own, and putting the label back to `addr = OP_Goto` / `JumpHere` would give the same behaviour.

Oracle failure: window1-10.3 (`LIMIT 5`) hits the assertion `resolveP2Values: pOp->p2>0 || ...OPFLG_JUMP0` in the build. In a non-assert build, a LIMIT would jump to address 0 and misbehave. window1-10.4 (LIMIT with OFFSET) is the same case, but the run aborted at 10.3 before reaching it.
