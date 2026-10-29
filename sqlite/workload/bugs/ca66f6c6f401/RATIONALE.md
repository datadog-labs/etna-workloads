# Rationale

## src/btree.c, sqlite3BtreeInsert()
The fix added `&& (!ISAUTOVACUUM || szNew<pPage->minLocal)` to the
"overwrite old cell in place" condition (and a comment). In 3.54.1 the same
condition exists as `!ISAUTOVACUUM(p->pBt) || szNew<pPage->minLocal`. I removed
it (and its comment), restoring the pre-fix condition
`info.nSize==szNew && info.nLocal==info.nPayload`.

Effect: in an auto-vacuum database, a row with no overflow replaced by a
same-cell-size row that now uses overflow pages is memcpy'd over the old cell,
skipping insertCell(), so the PTRMAP_OVERFLOW1 entry is never written.

## Oracle
autovacuum-10.1 fails: integrity_check reports
"Bad ptr map entry key=4 expected=(3,3) got=(3,0)". All other cases pass.
