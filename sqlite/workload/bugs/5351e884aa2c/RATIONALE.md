# Rationale

## Changed hunk: `renameResolveTrigger` in src/alter.c

The fix added a call to `sqlite3ViewGetColumnNames(pParse, pParse->pTriggerTab)`
after `pParse->eTriggerOp = pNew->op;`, and made the WHEN-clause resolution
conditional on `rc==SQLITE_OK`. In 3.54.1 that code is written as
`if( ALWAYS(pParse->pTriggerTab) ){ rc = sqlite3ViewGetColumnNames(...)!=0; }`.
I removed that block, which restores the pre-fix behaviour. The view's columns
are no longer loaded before the INSTEAD OF trigger body is resolved. The
`rc==SQLITE_OK` conditions are harmless without the call, so I left them.

## Oracle failures

`altertab-15.1` (`INSERT INTO v1 ...; ALTER TABLE t2 RENAME TO t3`) fails with
`Assertion 'i<nCol' failed` in `sqlite3ColumnIndex`. Resolving `NEW.a` in the
trigger body hits a view with no column list loaded. The later cases in test 15
(15.2 to 15.5) are not run because the assertion aborts the process.
