# Rationale

Fix hunk reversed: in `windowCodeOp()`, the fix added a check (for RANGE
FOLLOWING..FOLLOWING frames, op==WINDOW_AGGINVERSE) that compares the rowids of
the start and end cursors and jumps to lblDone so the start cursor never
advances past the end cursor when (a>b). In 3.54.1 this code was generalised
to also cover PRECEDING..PRECEDING (the fix's "peer is numeric" test in
windowAggStep was replaced by this). I removed the AGGINVERSE rowid
comparison in that block (src/window.c, windowCodeOp), restoring the pre-fix
behaviour where the start cursor can overtake the end cursor.
The `else if( p->regRowid )` end-cursor guard is left intact.

Oracle: test/windowB.test fails at windowB-5.1 with an assertion
failure in sqlite3VdbeExec (`pMem->uTemp==0x1122e0e3`), i.e. the
RANGE a FOLLOWING AND b FOLLOWING (a>b) cases misbehave.
