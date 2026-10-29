# Rationale

Fix (ticket #2415): when the progress handler returned non-zero, the old code
called `sqlite3_interrupt(db)`, which sets the connection-wide interrupt flag
and so aborts *all* active statements. The fix instead aborted only the
current VDBE (`rc = SQLITE_INTERRUPT; goto vdbe_halt`).

## Changes (src/vdbe.c)
Two progress-callback sites (the `check_for_interrupt` block in OP_Init/Goto
path, and the one at the end of the opcode loop) now call
`sqlite3_interrupt(db)` when `xProgress` returns non-zero, before setting
`rc = SQLITE_INTERRUPT`. This reverses the first vdbe.c hunk (the removed
`sqlite3_interrupt(db)` call). The current code's per-statement abort path is
kept, but the added global flag makes other active statements abort as well.

The vdbeaux.c hunk (read-only statements not rolling back on interrupt) was
not reverted; it is not needed to restore the visible bug.

## Oracle
`progress-1.7` fails with "interrupted": the outer SELECT is aborted by the
global interrupt flag set by the inner query's progress handler.
