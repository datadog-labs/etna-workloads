# Rationale

Fix hunk (src/update.c): for a one-pass UPDATE of a table with virtual columns, code an
extra OP_Column before OP_Delete/OP_Insert so a pending OP_SeekDeferred is resolved.

In 3.54.1 that role is played by `OP_FinishSeek`, emitted when `bFinishSeek` is set
(src/update.c, after `sqlite3WhereOkOnePass`). I reverted it for exactly the case the fix
covered: `eOnePass!=ONEPASS_OFF && (tabFlags & TF_HasVirtual)`, set `bFinishSeek = 0`.
So no seek-resolving opcode is coded, same as pre-fix.

Oracle failure: gencol1-18.20 hits `Assertion pC->deferredMoveto==0` in sqlite3VdbeExec
(OP_Delete on an unresolved deferred seek), the ticket ec8abb025e78f40c symptom.
