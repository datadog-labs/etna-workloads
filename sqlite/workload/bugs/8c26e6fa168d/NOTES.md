repro.sql: INSERT ... RETURNING rowid on a view with an INSTEAD OF trigger (returning1-10.3a).
codeReturningTrigger checks `pParse->nErr==0` (clean) vs `!db->mallocFailed` (buggy) after expanding RETURNING.
Clean reports "no such column: new.rowid"; buggy reports "no such column: rowid" with an error-position caret.
Both exit 1; only the error text differs.
