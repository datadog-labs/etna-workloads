# Rationale

The fix made temp-namespace access set XACT_FLAGS_ACCESSEDTEMPNAMESPACE so PREPARE TRANSACTION is rejected. In current code the flag is shared with temp-rel access and is set in several places. I removed the flag-setting at the namespace-related sites (the PrepareTransaction check in xact.c is left intact, so it now never fires for namespace-only access):

- `src/backend/catalog/namespace.c`, `AccessTempTableNamespace()`: removed `MyXactFlags |= ...` (fix hunk: new AccessTempTableNamespace in namespace.c).
- `src/backend/commands/dropcmds.c`, `RemoveObjects()`: removed flag set for DROP in a temp namespace (dropcmds.c hunk).
- `src/backend/commands/extension.c`, `CreateExtensionInternal()`: removed flag set when the target schema is temp (extension.c hunk).
- `src/backend/commands/lockcmds.c`, `RangeVarCallbackForLockTable()`: removed flag set for LOCK on a temp relation, and the now-unused `relpersistence` variable (lockcmds.c hunk).

Effect: PREPARE TRANSACTION is again allowed after creating/locking/dropping objects in pg_temp or creating an extension in it.

Oracle cases expected to fail: `src/test/regress||temp`, `src/test/modules/test_extensions||test_extensions` (see oracle run results; not confirmed at time of writing).
