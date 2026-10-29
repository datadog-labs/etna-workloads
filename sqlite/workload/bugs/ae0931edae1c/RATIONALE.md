# Rationale

## Change: tree/src/update.c (sqlite3Update, after the BEFORE UPDATE row trigger)
The fix added `OP_NotExists iCur, addr, regOldRowid` right after
`sqlite3CodeRowTrigger(... TRIGGER_BEFORE ...)` so that if the trigger deleted the
row being updated, the loop jumps to the next row. In 3.54.1 that check is the
`if( pPk ) OP_NotFound else OP_NotExists ... labelContinue` block inside
`if( !isView )` after the BEFORE trigger. I removed that block (the later
reseek after constraint checks is a different, unrelated check and is left alone).
The column-reload loop that follows remains, so it now reads from a deleted row
and the UPDATE and AFTER triggers proceed for a row that no longer exists.

The vdbe.c hunk in the fix is a comment-only change; nothing to revert.

## Oracle failures
triggerC-7.3 and triggerC-7.6 fail: when a BEFORE UPDATE trigger deletes or
renames the row being updated, the UPDATE continues instead of skipping the row.
