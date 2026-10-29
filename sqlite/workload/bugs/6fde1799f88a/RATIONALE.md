# Rationale

Changed one line: `src/window.c`, `windowReturnOneRow()`, the nth_value `OP_Column` now reads
from `pWin->iEphCsr` instead of `pMWin->iEphCsr`.

Reverses the fix's hunk `-OP_Column, pWin->iEphCsr ... +OP_Column, pMWin->iEphCsr` in
windowReturnOneRow. Only the master window (pMWin) has `iEphCsr` assigned (in sqlite3WindowCodeStep's
setup); other Window objects in the list do not, so nth_value() combined with other window functions
reads from the wrong cursor.

Other hunks (OOM handling in parse.y, last_valueStepFunc, sqlite3WindowRewrite) were not reverted:
the OOM-only changes are not needed for the main bug.

Oracle failure: window4 case 8.1/8.2 (nth_value alongside row_number/lead) hit
`Assertion p2<(u32)pC->nField ...` in sqlite3VdbeExec (OP_Column on the wrong cursor); windowfault also runs the same query.
