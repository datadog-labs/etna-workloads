# Rationale
- File: src/backend/commands/functioncmds.c, function ExecuteCallStmt.
- Traces to the single fix_impl.patch hunk. I removed the block that forces `callcontext->atomic = true` when `prosecdef` is set.
- With the block gone, security definer procedures can run transaction commands (COMMIT/ROLLBACK) again. The fix was there because StartTransaction() needs an empty security context stack and AbortTransaction() resets it.

Failing oracle case: src/pl/plpgsql/src||plpgsql_transaction
