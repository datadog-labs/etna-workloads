# Rationale

Fix hunk (src/insert.c, sqlite3GenerateConstraintChecks): before halting on a
failed CHECK constraint, `if( onError==OE_Replace ) onError = OE_Abort;`.

In 3.54.1 the same line exists in the CHECK block (tagged R-26383-51744), just
before `sqlite3HaltConstraint(pParse, SQLITE_CONSTRAINT_CHECK, onError, ...)`.
I removed that line, so REPLACE is passed through as the halt's conflict
mode. A failing CHECK under REPLACE then behaves as a statement-level
failure that rolls back the whole transaction instead of ABORT.

Oracle failure: conflict-13.2 fails ("cannot commit - no transaction is
active"), because the failed REPLACE in 13.1 rolled back the open transaction.
