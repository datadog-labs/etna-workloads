# Rationale

Fix hunk reversed: the `OP_Once` change in `src/vdbe.c`. The fix added a `p->pFrame` branch that uses a per-frame bitmask (`VdbeFrame.aOnce`) so that OP_Once works inside sub-programs (triggers). Before the fix, every OP_Once used the self-altering-code trick: compare `pOp->p1` with `aOp[0].p1` and jump if they match, otherwise copy the Init value into `pOp->p1`.

In 3.54.1 I removed the `p->pFrame` branch (and the now-unused `iAddr`). OP_Once now always uses the P1 comparison. This is the pre-fix behaviour. The sub-program code is shared between recursive trigger invocations, so the second (recursive) invocation sees the already-updated P1 and wrongly jumps over the once-only initialization.

The OP_Program allocation and `aOnce` field setup (the other hunks) are left in place. They are harmless without the consumer and are not needed to bring the bug back.

# Oracle result
`test/triggerG.test` fails: triggerG-100 hits the assertion `pC!=0` in sqlite3VdbeExec. The IN-list/ephemeral-index setup guarded by OP_Once is skipped in the recursive trigger. All 8 oracle cases are reported failing, since the run aborts.
