repro.sql: creates two tables with identical CHECK constraints, runs PRAGMA integrity_check,
then EXPLAINs INSERT INTO x SELECT * FROM t8.

Clean: integrity_check codegen works on a copy of pTab->pCheck, so the xfer optimization
still applies (EXPLAIN shows RowData/Insert), exit 0.
Buggy: integrity_check uses the table's own pCheck expressions directly; the shell aborts with
assertion `!ExprHasVVAProperty(pExpr, EP_Immutable)' in sqlite3ExprIfTrue (exit -6).
(In release builds the shared, resolved CHECK expr would disable xfer, as in insert4-10.3.)
